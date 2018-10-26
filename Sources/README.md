# udacity-ios-FinalProject

This is my final project for the Udacity "iOS Developer Nanodegree" Program


# Table of Contents
* [App Description](#description)<br />
* [Project Details](#projectdetails)<br />
* [App Requirements](#appreq)<br />

<a name="description">

## App Description

This app allows users to track fitness workouts (Running/Cycling.) Users can get basic workout data such as pace, time and distance as well as viewing their location on a map. 
Once a workout is finished, users can choose to save, delete or share the workout with Strava. They can also view past workouts in the workout log.


<a name="projectdetails">

## Project Details

### User Interface

* Main View Controllers:
- Choose workout type (Run/Bike)
- Workout view controller to initialize the data object and allow the user to swipe views
- Workout data view controller to view workout data in a table 
- Workout map view controller to view the user location on a map
- Workout finished view controller to allow the user to save, share and/or delete the workout
- Workout log view controller to show past workouts
- Workout detail view controller to view the details of past workouts
- Settings view controller to allow the user to authorize the app for the Strava API


### Networking

* Strava API (https://www.strava.com/api/v3/) is used to post workouts as GPX file:
- Workout type
- Locations (incl. coordinates and timestamps)
- Other required XML information


### Persistence

* Workouts are stored in Core Data
* Strava Authorization Token is saved in NSUserDefaults


## App Requirements

In order to test the Strava upload the user needs to have a Strava account and authorize this app for Strava in "Settings"
