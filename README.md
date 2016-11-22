# AC3.2-OAuth2
Handling APIs that Require OAuth2

### Reading:
1. [An Introduction to OAuth2 - Digital Ocean](https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2)
  - Kind of lengthy, but very well explained and diagrammed
2. [Authentication versus Authorization](http://stackoverflow.com/questions/6556522/authentication-versus-authorization)
3. [iOS AppDelegate Lifecycle - coursetro via Youtube](https://www.youtube.com/watch?v=silrqFmux-s)
4. [What is an app delegate in iOS? - Learn App Development via Youtube](https://www.youtube.com/watch?v=8p3RVXtY2k8)

### Reference: 
1. [Twitter API Documentation](https://dev.twitter.com/overview/api)
2. [Instagram API Documentation - Authentication](https://www.instagram.com/developer/authentication/)
3. [Github API Documentation - OAuth](https://developer.github.com/v3/oauth/)

### Optional: 
1. [User Authentication With OAuth 2.0 - OAuth.net](https://oauth.net/articles/authentication/)
2. [App Lifecycle - Apple](https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/TheAppLifeCycle/TheAppLifeCycle.html)

---
### Lesson Objectives
- Review remaining exercises for PUT/DELETE from tuesday
- Introduce the concept of an OAuth flow
- Briefly go over `AppDelegate` functions
- Briefly go over app lifecycle
- Implement an OAuth flow from beginning to end using an "Implicit Flow"
- Time permitting, start making calls to the GithubAPI to star/unstar repos

---
### Lesson Roadmap

1. Creating `GithubOAuthManager` 
2. Making a `GET` request to Github's authorization server
3. Write code to accept a valid response from Github
4. Make a `POST` request to Github's access token server
5. Inspect response from Github
  - Peek at what exactly is in the `URLResponse`
  - Parse `Data` into `String`
6. Change `Accept` header in `POST` request to `application/json`
  - Parse `Data` using `JSONSerialization`
7. Creating `GithubRequestManager`
8. TBD
  

---
### Exercises

1. Recreate the above OAuth login functionality for the Slack API
2. Add a collection view to our Gitrest app, populate it with your starred repos
3. Add a search bar with a default search on the most popular swift repos. Tapping on a cell should "star" the repo
