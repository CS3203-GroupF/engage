use std::sync::Arc;
use tokio::sync::RwLock;

/// A database of people.
#[derive(Clone, Debug, PartialEq, PartialOrd)]
#[non_exhaustive]
pub struct LoginDb {
    people: Vec<Person>,
}

impl LoginDb {
    // TODO: replace anyhow err type with a customized error
    /// Creates a new database.
    pub fn new() -> Result<Self, anyhow::Error> {
        Ok(Self { people: vec![] })
    }

    /// Connects to the database (shim).
    pub async fn connect(s: Arc<RwLock<Self>>) -> Result<Login, anyhow::Error> {
        Login::connect(s)
    }

    /// Adds a person to the database (shim).
    pub async fn push(&mut self, person: Person) -> Result<(), anyhow::Error> {
        self.people.push(person);
        Ok(())
    }
}

/// A login session.
pub struct Login {
    link: Arc<RwLock<LoginDb>>,
}

impl Login {
    /// Connects to the database.
    pub fn connect(db: Arc<RwLock<LoginDb>>) -> Result<Self, anyhow::Error> {
        Ok(Self {
            link: Arc::clone(&db),
        })
    }

    /// Logs in a user.
    pub async fn login(
        &self,
        _4x4: impl AsRef<str>,
        _2fa: TwoFactorCode,
    ) -> Result<Person, anyhow::Error> {
        let _4x4 = _4x4.as_ref().to_string();
        let _2fa = _2fa.code;
        // TODO: check 4x4 and 2fa

        let lock = self.link.read().await;

        let person = lock.people.iter().find(|person| person.user_4x4() == _4x4);
        match person {
            Some(person) => Ok(person.clone()),
            None => Err(anyhow::anyhow!("User not found")),
        }
    }
}

/// An organization at the University of Oklahoma.
#[derive(Clone, Debug, PartialEq, PartialOrd, Default)]
#[non_exhaustive]
pub struct Organization {
    name: String,
}

impl Organization {
    /// Sets the name of the organization.
    pub fn with_name(mut self, name: impl AsRef<str>) -> Self {
        self.name = name.as_ref().to_string();
        self
    }
}

/// A list of organizations.
pub type OrganizationList = Vec<Organization>;

/// A person that can log in.
#[derive(Clone, Debug, PartialEq, PartialOrd, Default)]
#[non_exhaustive]
pub struct Person {
    name: String,
    email: String,
    orgs: OrganizationList,
    _4x4: String,
    _2fa: String,
    debug_2fa_codes: Option<Vec<String>>, // TODO: move to shim
}

impl Person {
    /// Creates a new person with default values.
    pub fn new() -> Self {
        Self {
            name: Default::default(),
            email: Default::default(),
            orgs: Default::default(),
            _4x4: Default::default(),
            _2fa: Default::default(),
            debug_2fa_codes: Default::default(),
        }
    }

    /// Sets the name of the person.
    pub fn with_name(mut self, name: impl AsRef<str>) -> Self {
        self.name = name.as_ref().to_string();
        self
    }

    /// Sets the organizations of the person.
    pub fn with_orgs(mut self, orgs: OrganizationList) -> Self {
        self.orgs = orgs;
        self
    }

    /// Sets the 4x4 code of the person.
    pub fn with_4x4(mut self, fourfour: impl AsRef<str>) -> Self {
        self._4x4 = fourfour.as_ref().to_string();
        self
    }

    /// Sets the 2fa code of the person.
    pub fn with_2fa(mut self, twofa: impl AsRef<str>) -> Self {
        self._2fa = twofa.as_ref().to_string();
        self
    }

    /// Sets the allowed 2fa codes of the person.
    pub fn with_allowed_2fa_code(mut self, code: impl AsRef<str>) -> Result<Self, anyhow::Error> {
        let code = code.as_ref().to_string();
        if self.debug_2fa_codes.is_none() {
            self.debug_2fa_codes = Some(vec![]);
        }
        self.debug_2fa_codes.as_mut().unwrap().push(code.clone());
        Ok(Self { _2fa: code, ..self })
    }

    /// Returns the name of the person.
    pub fn name(&self) -> String {
        self.name.clone()
    }

    /// Returns the email of the person.
    pub fn email(&self) -> String {
        self.email.clone()
    }

    /// Returns the 4x4 code of the person.
    pub fn user_4x4(&self) -> String {
        self._4x4.clone()
    }

    /// Returns the organizations of the person.
    pub fn orgs(&self) -> &OrganizationList {
        &self.orgs
    }
}

/// A 2fa code.
pub struct TwoFactorCode {
    code: String,
}

impl TwoFactorCode {
    /// Creates a new 2fa code.
    pub fn new(code: impl AsRef<str>) -> Self {
        // TODO: validate the code
        Self {
            code: code.as_ref().to_string(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn try_login() -> anyhow::Result<()> {
        let shim_db = Arc::new(RwLock::new(LoginDb::new()?)); // a fake login db for this test
        let auth = Login::connect(shim_db.clone())?;

        let ou_aises_org = Organization::default().with_name("OU AISES");

        let person = Person::new()
            .with_name("Barrett Ray")
            .with_orgs(OrganizationList::from([ou_aises_org.clone()]))
            .with_4x4("ray1234")
            .with_2fa("barrettray@ou.edu")
            .with_allowed_2fa_code("123456")?; // shim only!

        shim_db.write().await.push(person).await?; // shim only!

        // try logging in
        let test_user = auth
            .login("ray1234", TwoFactorCode::new("123456"))
            .await
            .expect("login should work"); // make sure it worked

        // check that name is right2fa
        assert_eq!(test_user.name(), "Barrett Ray");

        // check 4x4 is correct
        assert_eq!(test_user.user_4x4(), "ray1234");

        // check we're in the 'OU AISES' org
        assert!(test_user.orgs().iter().any(|org| org == &ou_aises_org));

        Ok(())
    }
}
