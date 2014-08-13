jobbed
================

Reed API keys: 

- jobId
- employerId
- employerName
- employerProfileId
- employerProfileName
- jobTitle
- locationName
- minimumSalary
- maximumSalary
- currency
- expirationDate
- date
- jobDescription
- applications

================

To do/fix:

- number of jobs from query and number of jobs shown by the app not matching.
- result = JSON.parse(response.body) makes app crash if response is nil
- rename app.rb to jobbed.rb
- convert if possible all the instance variable to local variable
- add test coverage
- make it look pretty
- rename methods and variables
- remove/add/reword comments where needed
- simplify methods
- check if user inputs more than one word
	- format spaces into '-'
- add "Download CSV file" button
	- make CSV file downloadable


In progress:

Done:
- query through each api result updating the url
	- permit only one unique instance of each job
	- update the url when <1000 and >1000 total results

