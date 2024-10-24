/**
 * @jest-environment jsdom
 */

const { screen, fireEvent } = require('@testing-library/dom');
require('@testing-library/jest-dom/extend-expect');

// Mock the HTML structure
document.body.innerHTML = `
    <input type="text" id="search-bar" placeholder="Search for events..." onkeyup="filterEvents()">
    <ul id="event-list">
        <li class="event-item" data-tags="Sports">
            <h2>OU Football Game</h2>
            <p>Date: October 28, 2024</p>
            <p>Time: 3:00 PM</p>
            <p>Location: OU Stadium</p>
        </li>
        <li class="event-item" data-tags="Technology">
            <h2>Tech Talk: Innovations in AI</h2>
            <p>Date: November 5, 2024</p>
            <p>Time: 1:00 PM</p>
            <p>Location: Tech Hall</p>
        </li>
        <li class="event-item" data-tags="Music">
            <h2>OU Jazz Concert</h2>
            <p>Date: November 12, 2024</p>
            <p>Time: 7:00 PM</p>
            <p>Location: Music Auditorium</p>
        </li>
    </ul>
`;

// Mock the filter functions
function filterEvents() {
    let input = document.getElementById('search-bar').value.toLowerCase();
    let items = document.getElementsByClassName('event-item');
    let searchWords = input.split(' ');
    let noResults = true;

    for (let i = 0; i < items.length; i++) {
        let item = items[i];
        let itemText = item.innerHTML.toLowerCase();
        let match = searchWords.some(word => itemText.includes(word));

        if (match) {
            item.style.display = "";
            noResults = false;
        } else {
            item.style.display = "none";
        }
    }

    if (noResults) {
        if (!document.getElementById('error-message')) {
            let errorMessage = document.createElement('p');
            errorMessage.id = 'error-message';
            errorMessage.textContent = 'No events found.';
            document.getElementById('event-list').appendChild(errorMessage);
        }
    } else {
        let errorMessage = document.getElementById('error-message');
        if (errorMessage) {
            errorMessage.remove();
        }
    }
}

function filterByTag(tag) {
    let items = document.getElementsByClassName('event-item');
    let noResults = true;

    for (let i = 0; i < items.length; i++) {
        let item = items[i];
        let itemTags = item.getAttribute('data-tags');

        if (itemTags.includes(tag)) {
            item.style.display = "";
            noResults = false;
        } else {
            item.style.display = "none";
        }
    }

    if (noResults) {
        if (!document.getElementById('error-message')) {
            let errorMessage = document.createElement('p');
            errorMessage.id = 'error-message';
            errorMessage.textContent = 'No events found.';
            document.getElementById('event-list').appendChild(errorMessage);
        }
    } else {
        let errorMessage = document.getElementById('error-message');
        if (errorMessage) {
            errorMessage.remove();
        }
    }
}

// Tests
test('filters events by search input', () => {
    const searchBar = screen.getByPlaceholderText('Search for events...');
    fireEvent.input(searchBar, { target: { value: 'football' } });

    expect(screen.getByText('OU Football Game')).toBeVisible();
    expect(screen.queryByText('Tech Talk: Innovations in AI')).not.toBeVisible();
    expect(screen.queryByText('OU Jazz Concert')).not.toBeVisible();
    expect(screen.queryByText('No events found.')).not.toBeInTheDocument();
});

test('filters events by partial search input', () => {
    const searchBar = screen.getByPlaceholderText('Search for events...');
    fireEvent.input(searchBar, { target: { value: 'tech' } });

    expect(screen.getByText('Tech Talk: Innovations in AI')).toBeVisible();
    expect(screen.queryByText('OU Football Game')).not.toBeVisible();
    expect(screen.queryByText('OU Jazz Concert')).not.toBeVisible();
    expect(screen.queryByText('No events found.')).not.toBeInTheDocument();
});

test('displays error message when no events match search input', () => {
    const searchBar = screen.getByPlaceholderText('Search for events...');
    fireEvent.input(searchBar, { target: { value: 'nonexistent event' } });

    expect(screen.getByText('No events found.')).toBeVisible();
});

test('filters events by tag', () => {
    filterByTag('Technology');

    expect(screen.getByText('Tech Talk: Innovations in AI')).toBeVisible();
    expect(screen.queryByText('OU Football Game')).not.toBeVisible();
    expect(screen.queryByText('OU Jazz Concert')).not.toBeVisible();
    expect(screen.queryByText('No events found.')).not.toBeInTheDocument();
});

test('displays error message when no events match tag', () => {
    filterByTag('Nonexistent Tag');

    expect(screen.getByText('No events found.')).toBeVisible();
});
