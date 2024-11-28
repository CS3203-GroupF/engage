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
    setHref("contact", "contacts.html")
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