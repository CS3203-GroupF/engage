// html.test.js

// Mock the DOM structure using jsdom

document.body.innerHTML = `
    <nav class="navbar">
        <ul>
            <li><img src="images/EngageLogo.png" class="logo"></li>
            <div class="center-nav">
                <li><a class="organizations" href="organizations.html" target="_blank">Organizations</a></li>
                <li><a class="about" href="about.html" target="_blank">About</a></li>
                <li><a class="contact" href="contact.html" target="_blank">Contact</a></li>
            </div>
            <li class="right"><button class="signIn"><a href="signin.html">Sign In</a></button></li>
        </ul>
    </nav>
    
    <h1 class="header">Organizations</h1>

    <div class="search-container">
        <input type="text" id="search-bar" placeholder="Search for organizations..." onkeyup="filterOrganizations()">
    </div>

    <div class="tag-container">
        <button class="tag" onclick="filterByTag('Sports')">Sports</button>
        <button class="tag" onclick="filterByTag('Technology')">Technology</button>
        <button class="tag" onclick="filterByTag('Music')">Music</button>
        <button class="tag" onclick="filterByTag('Art')">Art</button>
        <button class="tag" onclick="filterByTag('Community')">Community</button>
    </div>

    <ul id="organization-list">
        <li class="organization-item" data-tags="Sports">OU Football Club</li>
        <li class="organization-item" data-tags="Technology">OU Tech Enthusiasts</li>
        <li class="organization-item" data-tags="Music">OU Choir</li>
        <li class="organization-item" data-tags="Art">OU Art Collective</li>
        <li class="organization-item" data-tags="Community">OU Volunteer Group</li>
    </ul>
`;

// Example JavaScript functions to be tested
function filterOrganizations() {
    let input = document.getElementById('search-bar').value.toLowerCase();
    let items = document.getElementsByClassName('organization-item');

    for (let i = 0; i < items.length; i++) {
        let item = items[i];
        if (item.innerHTML.toLowerCase().includes(input)) {
            item.style.display = "";
        } else {
            item.style.display = "none";
        }
    }
}

function filterByTag(tag) {
    let items = document.getElementsByClassName('organization-item');

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

// Jest test cases
describe('HTML Structure and Interaction Tests', () => {

    test('Search bar exists and is properly configured', () => {
        const searchBar = document.getElementById('search-bar');
        
        expect(searchBar).not.toBeNull();
        expect(searchBar.placeholder).toBe('Search for organizations...');
        expect(searchBar.tagName).toBe('INPUT');
    });

    test('Organization list contains correct number of items', () => {
        const organizationItems = document.getElementsByClassName('organization-item');
        
        expect(organizationItems.length).toBe(5);
    });

    test('Tag buttons exist', () => {
        const tagButtons = document.getElementsByClassName('tag');
        
        expect(tagButtons.length).toBe(5); // We expect 5 tags: Sports, Technology, Music, Art, Community
    });

    test('filterOrganizations function filters correctly', () => {
        const searchBar = document.getElementById('search-bar');
        const organizationItems = document.getElementsByClassName('organization-item');
        
        // Simulate entering "Tech" in the search bar
        searchBar.value = 'Tech';
        filterOrganizations();
        
        // Check that only "OU Tech Enthusiasts" is visible
        expect(organizationItems[0].style.display).toBe('none'); // OU Football Club
        expect(organizationItems[1].style.display).toBe(''); // OU Tech Enthusiasts
        expect(organizationItems[2].style.display).toBe('none'); // OU Choir
        expect(organizationItems[3].style.display).toBe('none'); // OU Art Collective
        expect(organizationItems[4].style.display).toBe('none'); // OU Volunteer Group
    });

    test('filterByTag filters by tag correctly', () => {
        const organizationItems = document.getElementsByClassName('organization-item');
        
        // Simulate clicking on the "Sports" tag
        filterByTag('Sports');
        
        // Only the sports-related organization should be visible
        expect(organizationItems[0].style.display).toBe(''); // OU Football Club
        expect(organizationItems[1].style.display).toBe('none'); // OU Tech Enthusiasts
        expect(organizationItems[2].style.display).toBe('none'); // OU Choir
        expect(organizationItems[3].style.display).toBe('none'); // OU Art Collective
        expect(organizationItems[4].style.display).toBe('none'); // OU Volunteer Group
    });

});
