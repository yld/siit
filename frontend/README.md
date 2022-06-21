# Siit Frontend Challenge

## Guidelines

- Make sure you have `git`, `node`, and `npm` or `yarn` installed locally
- Clone this repo (do **not** fork it)
- Solve the levels in ascending order
- Only do one commit per level and include the `.git` directory when submitting your test
- To start the app:
  - run `yarn install` or `npm install`
  - run `yarn start` or `npm run start`
- Edit files in `./src`

## Pointers

You can have a look at the higher levels, but please do the simplest thing that could work for the level you're currently solving.

We are interested in seeing code that is clean, extensible and robust, so don't overlook edge cases.

We don't expect you to be a top-notch designer, but we want to see how you would handle some styling of this app. Do not hesitate to take inspiration from Siit or anywhere else!

This test is framework agnostic, feel free to stick to vanilla HTML/JS/CSS or go with anything else. If you plan on using something else (e.g. React, Vue, TypeScript, styled components, ...), you'll find info on how to set it up in [Parcel's documentation](https://en.parceljs.org/recipes.html).

## Sending Your Results

You can send your Github project link or zip your directory and send it via email.
If you do not use Github, don't forget to attach your `.git` folder.

Good luck!

---

## Challenge

We are building an employee platform. Let's call it Siit :)
Companies can already fetch infos from their different SAAS and backend developers have provided an API for us to query.

Our plan is to display these informations.

### Level 1: Fetching our employees

For this first version, we want to list all our users with their profile pic, name, position. Display these information on the index page.

This API is accessible with a `GET` request at `/users.json` on your local server.

### Level 2: Fetching our services

We now want to list all the services that the company is using, along with their logo, and a link to open the service's homepage on a new tab.

This API is accessible with a `GET` request at `/services.json` on your local server. Show these information on the same index page below the user list.

### Level 3: Showing users of a given service

We now want to filter our users by service. Example: clicking on the Payfit service should only display two users.

You can use the route `GET /users.json?service_id=xxx` by replacing with the correct `service_id` on your local server.

### Level 4: Showing price information

For each service, we want to see the monthly cost. Use the fields `price` on the `service.json` enpdoint to compute the monthly price as follow:

- MONTHLY_COST = FLAT_COST + COST_PER_USER * (NB_USERS_USING_THE_SERVICE - NB_USERS_INCLUDED)
