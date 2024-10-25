function signin() {
    var input1 = document.getElementById("username").value
    var input2 = document.getElementById("password").value
    if (input1 == "") {
        alert("Please enter a username")
    }
    else if (input2 == "") {
        alert("Please enter a password")
    }
    else if (input1 == "null") {
        alert("Invalid username")
    }
    else {
        window.location.href = "about.html?user=" + input1
    }
    return false;
}

function getURL(URL) {
    const searchParams = new URLSearchParams(window.location.search)
    return URL + "?user=" + searchParams.get('user');
}

function setHref(id, URL) {
    document.querySelector('#' + id).setAttribute("href", getURL(URL))
}

function setNavBarHrefs() {
    setHref("organizations", "organizations.html")
    setHref("about", "about.html")
    setHref("contact", "contacts.html")
}