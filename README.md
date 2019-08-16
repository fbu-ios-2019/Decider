Munch
===
**Katelin Chan, Mary Pestana, and Mohamed Ally**

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)
2. [Video Walkthrough](#Video-Walkthrough)

## Overview
### Description
Food & Drink / Travel app that displays pictures of food and allows the user to swipe left or right. Depending on liked and unliked images, a restaurant recommendation will be given based on price, location, reviews, and number of stars.

### App Evaluation
- **Category:** Food & Drink / Travel
- **Mobile:** This app is primarily for mobile experience, maps are used to help navigate to the decided place.
- **Story:** A user can easily use this app to decide on a place to eat instead of wasting time arguing with friends and family.
- **Market:** Anyone who is interested in food and looking for a place to eat at.
- **Habit:** Users will use this application daily/weekly depending on how often they go out for food.
- **Scope:** The application is very UI heavy and specific aspects are focused on design. The Yelp API will be utilized to display images and help test the swipe functionality.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* User can limit food options by choosing a specific category and setting their location
* User can swipe left or right on each image of food, left for "don't like" and right for "like".
* User can see several images of the same restaurant.
* User can see a detailed view of a restaurant by clicking on a food image.
* User can select a checkmark button to finish swiping.
* User can see the Decider's recommendation on which restaurant to go to based on:
    * Number of likes per restaurant
    * Price
    * Number of stars
    * Reviews
* User can see a detailed view of the recommended restaurant including reviews, number of stars, price range, location, and pictures of the menu.
* User can see on a map the location of the restaurant.
* User can save and unsave restaurants we recommend to their profile
* User can see saved restaurants from their profile

**Optional Nice-to-have Stories**
* User sees an error message when there's a networking error.
* Load a low resolution image first and then switch to a high resolution image when complete.
* User can choose to see three recommendations (instead of only one) in a "Settings" screen.
    * User can see the three recommendations on the map.
* User can search for a restaurant.
* User can choose between deciding food and touristic places.
* User can see a changing emoji when swiping the pictures.
* User can view restaurants in a list form.
* User can add a price range filter (where only images of restaurants inside his budget are considered).
* User can share the Munch's recommendation via WhatsApp, Messenger, and more.
* User can create an account and set it up.
    * User can create an account using Yelp, Google, and Facebook.
    * User can see his past recommendations saved, as well as a list of his preferences.
    * User can receive recommendations from the app, without the need of swiping.
    * User can write a review and rate a restaurant.
* User can see previously recommender restaurants via a history tab
* User can edit their profile
   * User can change profile picture, change their name, and username
* User can choose what's more important to them when we recommend restaurants to them (by reordering our recommendation criteria)
* User can swipe to unsave a restaurant from the profile page

### 2. Screen Archetypes

* HomeViewController
    * User can limit food options by choosing a specific category
    * User can swipe left or right on each image of food, left for "don't like" and right for "like".
    * User can see several images of the same restaurant.
    * User can select a checkmark button to finish swiping.
    * User can see a detailed view of a restaurant by clicking on a food image.

* DetailsViewController
    * User can see a detailed view of the recommended restaurant including reviews, number of stars, price range, location, and pictures of the menu.

* DecisionViewController
    * User can see the Decider's recommendation on which restaurant to go to based on:
        * Number of likes per restaurant
        * Price
        * Number of stars
        * Reviews

* MapViewController
    * User can see on a map the distance to the restaurant.

Optional:
* ListViewController
* ProfileViewController

### 3. Navigation

**Flow Navigation** (Screen to Screen)

* HomeViewController
    * DetailsViewController
    * DecisionViewController
    * MapViewController

Optional:
* Tab Navigation (Tab to Screen)
    * HomeViewController
    * ListViewController
    * ProfileViewController

## Wireframes
![](https://i.imgur.com/TPD1kAM.png)

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema
Optional:
* Heroku and MongoDB, and Parse

### Models

* Restuarant
    * name (String)
    * images (NSArray of Files)
    * numberImages (Number)
    * reviews (NSArray of Strings)
    * numberReviews (Number)

### Networking
 - FoodViewController
    * GET https://api.yelp.com/v3/businesses/search
    this is for getting all restaurants by using keyword "restaurants" and setting the location parameter to the users current location.
    * GET https://api.yelp.com/v3/businesses/{id}
     this is for getting all the details for a certain restaurant such as photos, ratings, prices etc
     * GET https://www.googleapis.com/geolocation/v1/geolocate?key=YOUR_API_KEY
        this api gets the users current location which will be used as a string query parameter fo the get businesses/search Yelp API call.
        
- MapViewController
    * Google maps IOS https://developers.google.com/maps/documentation/ios-sdk/intro
        this API would be useful in opeining a map whena user taps ona specific business' location from the DetailsViewController. 
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/AYJulkxYpL.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://g.recordit.co/nf4F5aRKoY.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://g.recordit.co/uLQihSk2aU.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [Recordit](http://recordit.co/).
