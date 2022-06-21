# JustShareLah! (By: Praveen and Summer)

### Contents

- Deployment
- Motivation
- Aim
- User Stories
- Features
- Tech Stack
- Poster + Video Links
<hr>

### Deployment

Our latest release is published here on Github! The .apk (Android) and .ipa (iOS) files for the application **can be found under the “Releases” header.**

<hr>

### Motivation

#### Scenario 1

You are walking towards Central Library, ready to embark on a productive day of working on your software side projects. You find a seat and settle down, reaching out for your laptop and its charger. That’s when it hits you. Your charger is at home, which is an hour’s commute away. You don’t want to waste time going back home, so you are left with one option. Borrow a charger. There are bound to be people in your vicinity with a charger compatible with your device. Nonetheless, some are willing to lend and others not. So who are you going to approach? What if there was an easier way to find out who has the accessories you require, so as to streamline the search? (CS2040S _cough_ _cough_)

#### Scenario 2

You are an NUS Computer Science student compelled by the school to take a module to fulfill your Unrestricted Electives. You decided to take up Spanish 1. Little did you know, the first project, which contributes 40% to your overall grade, is a Photo Montage Project. The project requires high quality photos that have to be taken on a DSLR. As someone not keen on investing in an expensive camera, you pray for some rare kind soul to lend you their camera. But how do you find this kind soul…where would you go? Not everyone is willing to lend you their precious camera. What if there is a way for you to simply search for what expensive items that you need, rent it for a price from a willing party, and return once you are done?

<hr>

### Aim

We envision a mobile application that allows for seamless borrowing/lending/renting within communities.
<br>

<hr>

### User Stories

- As a user, I want to log in to my own personalised account to access the sharing marketplace.
- As a user, I want to scroll through a feed of listings.
- As a user, I want to have my own profile page where I can upload my profile picture, and view my listings, reviews and number of Share Credits.
- As a user, I want to search for items in my vicinity that I need to borrow/rent over a short duration of time
- As a user, I want to give and receive reviews to and from those who have transacted with me.
- As a user, I can list expensive items at home that otherwise have little daily utility to me.
- As a user, I can list items that I have on me currently, which I am willing to share.
- As a user, I want to edit my listings as required.
- As a user, I wish to chat with those I want to transact with.
- As a user, I want to manage all my chats on a single page.
- As a user, I want to monitor my activity in my account.
<hr>

### Features

The Mobile Application (compatible with both iOS and Android) first brings the user to a login/register page. After they log in, they will be directed to a landing page.
<br>

- **Landing Page + Feed**

  - The landing page contains a search bar in the middle
  - Users can scroll below the search bar to view item listings either
    - Ranked by proximity of the user listing the item, OR
    - By friends they follow on the application

- **Searching for items**

  - Users will be able to search for items to either
    - Borrow from those in their direct vicinity, for a short period of time (within a day), OR
    - Rent from anybody within Singapore, for an extended period of time (specified by the user, and agreed upon by the renter)
  - When searching, users can specify the following
    - Item being looked for
    - Period of time that the user is looking to borrow/rent the product
    - Price range of listing (Optional field for items being rented)
  - The ranking of search results will depend on the following factors
    - Reviews of renter
    - Location
    - Price range (input by the person searching, only applicable for items being rented)

- **Chat**

  - Before dealing with the lender/renter, users can chat with them to coordinate places to meet up to obtain the item listed, or for general purposes i.e. enquiries

- **Profile page and Listings**

  - Users can navigate to their profile page, where their current item listings are displayed
    - Item listings refer to products that the user is willing to lend/rent
    - These will contain information such as
      - Whether the item is up for borrowing or renting
      - Period of time that the user listing is willing to share that product
      - Price of the listing (for items being rented)
  - Users can add, remove or edit listings
  - Users can add other users as friends by visiting their profile

- **Share Credits**

  - Each user would have a certain amount of Share Credits when an account is created, which is displayed on their individual profiles
  - Share Credits would:
    - Increase every time a user lends an item to another party
    - Decrease every time the user borrows from another party
  - User will not be allowed to borrow once reaching a certain Share Credit floor
    - This incentivises users to lend their own items so that they are able to borrow more
  - Note that Share Credits are not affected by listings that involve monetary transaction (renting)

- **Reviews**
  - After each transaction is made (borrowing/lending or renting), users are prompted to leave a review for the other party
  - Reviews and ratings would be shown on each user’s profile - This assures users of the credibility of other parties - It also reduces the likelihood of errant / irresponsible users who would undermine the overall quality of services on our app
  <hr>

### Tech Stack

_Front-end:_ Flutter<br>
_Back-end:_ FireBase<br>
_User Authorization:_ FireBase Auth<br>
_CI/CD + Deployment:_ Github Actions

<hr>

### Poster + Video Link

Poster: [5011.pdf](https://drive.google.com/file/d/1lvXZxw3PGwX0bxjjKtWldovTyYTCKdrd/view?usp=sharing)<br>
Video: [5011.mp4](https://drive.google.com/file/d/1ON6u0wTBIKMeA11svlxJA-YJkGRfGv1m/view?usp=sharing)
