Group Project - README Template
===
**Katelin Chan, Mary Pestana, and Mohamed Ally**


# Decider

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Travel app that displays pictures of food/movies/places and allows the functionality to swipe left or right to help decide which place to go to based on location, reviews, or number of stars.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Travel
- **Mobile:** Mobile experience only, maps are used to help navigate to the decided place.
- **Story:** A user can easily use this application to decide on a place to go for food or entertainment instead of wasting time arguing with friends and family.
- **Market:** Anyone who is interested in food and entertainment or just traveling around.
- **Habit:** Users will use this application daily/weekly depending on how often they go out for food and entertainment or how often they travel.
- **Scope:** The application is very UI heavy and specific aspects are focused on design. An API of food will first be utilized to display images and help test the swipe functionality. More tabs will then be added for entertainment including movies and tourist attractions. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* User can view a list of restaurants near them from a food database.
* Food images are loaded using the UIImageView category in the AFNetworking library.
* User sees a loading state while waiting for the food API.
* User can pull to refresh the food list.
* User can swipe left and right on each image of food.
* User can see a detailed view of the restaurant after tapping on the food image.
* Algorithm decides on a specific restaurant based on right swipes and their reviews, location, and number of stars.

**Optional Nice-to-have Stories**

* User sees an error message when there's a networking error.
* User can search for a restaurant.
* Load a low resolution image first and then switch to a high resolution image when complete.
* Add a navigation bar.
* Customize the UI.
* Functionality for movies, tourist attractions, etc.
* User can click on address and see map details.

### 2. Screen Archetypes

* FoodListViewController
* User can view a list of restaurants near them from a food database.
* User sees a loading state while waiting for the food API.
* User can pull to refresh the food list.
* User can search for a restaurant.
* FoodViewController
* Food images are loaded using the UIImageView category in the AFNetworking library.
* User can swipe left and right on each image of food.
* DecisionViewController
* Algorithm decides on a specific restaurant based on right swipes and their reviews, location, and number of stars.
* DetailsViewController
* User can see a detailed view of the restaurant after tapping on the food image.
* MapViewController
* User can click on address and see map details.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* FoodListViewController
* MovieListViewController
* PlaceListViewController

**Flow Navigation** (Screen to Screen)

* FoodListViewController
* FoodViewController
* DetailsViewController
* DecisionViewController
* MapViewController
* MovieListViewController
* MovieViewController
* DetailsViewController
* DecisionViewController
* MapViewController
* PlaceListViewController
* PlaceViewController
* DetailsViewController
* DecisionViewController
* MapViewController

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
