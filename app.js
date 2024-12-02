//import { parse } from '@vanillaes/csv'

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
    setHref("events", "events.html")
    setHref("about", "about.html")
    setHref("contact", "contact.html")
}

// Function to filter organizations by search input
function filterBySearch(className) {
    let input = document.getElementById('search-bar').value.toLowerCase();
    let items = document.getElementsByClassName(className);

    for (let i = 0; i < items.length; i++) {
        let item = items[i];
        if (item.innerHTML.toLowerCase().includes(input)) {
            item.style.display = "";
        } else {
            item.style.display = "none";
        }
    }
}

// Function to filter organizations by selected tag
function filterByTag(tag, className) {
    let items = document.getElementsByClassName(className);

    for (let i = 0; i < items.length; i++) {
        let item = items[i];
        let itemTags = item.getAttribute('data-tags');

        if (itemTags.includes(tag)) {
            item.style.display = "";
        } else {
            item.style.display = "none";
        }
    }
}

function unfilter(className) {
    let items = document.getElementsByClassName(className);
    for (let i = 0; i < items.length; i++) {
        let item = items[i];
        item.style.display = "";
    }
}

// placeholder to simulate retrieving size from DB
function getOrganizationAmount() {
    return 5;
}

/*function getData(dataType, i) {
    const reader = new FileReader();
    reader.onload() = (e) => {
        const text = e.target.result;
        const array = parse(text);
        return array[i + 1][dataType];
    }
    reader.readAsText("backend\orgs.csv");

}*/

// placeholder to simulate retrieving org from DB
function getOrganization(i) {
    const orgs = ['OU Football Club', 'OU Tech Enthusiasts', 'OU Choir', 'OU Art Collective', 'OU Volunteer Group'];
    return orgs[i];
}

// placeholder to simulate retrieving tag from DB
function getOrgDataTag(i) {
    const orgTag = ['Sports', 'Technology', 'Music', 'Art', 'Community'];
    return orgTag[i];
}

function getOrgDesc(i) {
    const orgDesc = ['Sports', 'Technology', 'Music', 'Art', 'Community'];
    return orgDesc[i];
}

function getOrgContactName(i) {
    const orgName = ['Henry', 'Henry 2', '', 'Henry 4', 'Henry 5'];
    return orgName[i];
}

function getEmail(i) {
    const orgEmail = ['Henry@gmail', 'Henry 2@gmail', '', 'Henry 4@gmail', 'Henry 5@gmail'];
    return orgEmail[i];
}

function getPhoneNumber(i) {
    const orgNumber = ['111', '222', '', '444', '555'];
    return orgNumber[i];
}

function getAddr(i) {
    const orgAddr = ['111 Place', '222 Place', '', '444 Place', '555 Place'];
    return orgAddr[i];
}

function populateOrganizationList() {
    var ul = document.getElementById("organization-list");
    for (let i = 0; i < getOrganizationAmount(); i++) {
        var li = document.createElement("li");
        const heading = document.createElement("h2");
        heading.textContent = getOrganization(i);
        li.appendChild(heading);
        const description = document.createElement("p");
        description.textContent = getOrgDesc(i);
        li.appendChild(description);
        if (getOrgContactName(i).length > 0) {
            const contact = document.createElement("p");
            contact.textContent = "Contact Name: " + getOrgContactName(i);
            li.appendChild(contact);
        }
        if (getEmail(i).length > 0) {
            const email = document.createElement("p");
            email.textContent = "Email: " + getEmail(i);
            li.appendChild(email);
        }
        if (getPhoneNumber(i).length > 0) {
            const phone = document.createElement("p");
            phone.textContent = "Phone Number: " + getPhoneNumber(i);
            li.appendChild(phone);
        }
        if (getAddr(i).length > 0) {
            const address = document.createElement("p");
            address.textContent = "Address: " + getAddr(i);
            li.appendChild(address);
        }
        li.setAttribute('data-tags', getOrgDataTag(i));
        li.setAttribute('class', 'organization-item')
        ul.appendChild(li);
    }
}

// event functions are similar placeholders
function getEventAmount() {
    return 5;
}
function getEvent(i) {
    const events = ['OU Football Game', 'Tech Talk: Innovations in AI', 'OU Jazz Concert', 'Art Exhibition: OU Creatives', 'Community Volunteer Drive'];
    return events[i];
}
function getEventDataTag(i) {
    const eventTag = ['Sports', 'Technology', 'Music', 'Art', 'Community'];
    return eventTag[i];
}
function getDate(i) {
    const dates = ['October 28, 2024', 'November 5, 2024', 'November 12, 2024', 'November 20, 2024', 'December 1, 2024'];
    return dates[i];
}
function getTime(i) {
    const times = ['3:00 PM', '1:00 PM', '7:00 PM', '10:00 AM', '9:00 AM'];
    return times[i];
}

function getLocation(i) {
    const locations = ['OU Stadium', 'Tech Hall', 'Music Auditorium', 'Art Gallery', 'Community Center'];
    return locations[i];
}

function populateEventLists() {
    var ul = document.getElementById("event-list");
    for (let i = 0; i < getEventAmount(); i++) {
        var li = document.createElement("li");
        const heading = document.createElement("h2");
        heading.textContent = getEvent(i);
        const date = document.createElement("p");
        date.textContent = "Date: " + getDate(i);
        const time = document.createElement("p");
        time.textContent = "Time: " + getTime(i);
        const location = document.createElement("p");
        location.textContent = "Location: " + getLocation(i);
        li.appendChild(heading);
        li.appendChild(date);
        li.appendChild(time);
        li.appendChild(location);
        li.setAttribute('data-tags', getEventDataTag(i));
        li.setAttribute('class', 'event-item')
        ul.appendChild(li);
    }
}
