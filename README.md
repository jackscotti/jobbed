jobbed
================

Reed Search API parameters: 
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

Reed Details API parameters: 
- employerId
- employerName
- jobId
- jobTitle
- locationName
- minimumSalary
- maximumSalary
- yearlyMinimumSalary
- yearlyMaximumSalary
- currency
- salaryType
- datePosted
- expirationDate
- externalUrl
- jobUrl
- partTime
- fullTime
- contractType
- jobDescription
- applicationCount

================

To do/fix:

- fix number of jobs from query and number of jobs shown by the app not matching
- result = JSON.parse(response.body) makes app crash if response is nil
- convert if possible all the instance variables to local variables
- add test coverage
- make it look pretty
- rename methods and variables
- remove/add/reword comments where needed
- add "Download CSV file" button
	- make CSV file downloadable
- if salary is not specified show 'salary not specified'
- create error pages (404, etc.)
- divide main file into classes
- add 'back' link to details page
- fix json parse console error

In progress:
- simplify methods
- refactor
- add job description page

Done:
- query Reed Search API
	- query through each api result updating the url
		- permit only one unique instance of each job
		- update the url when <1000 and >1000 total results
- rename app.rb to jobbed.rb
- check if user inputs more than one word
	- format spaces into '-'
- query Reed Details API
- wire index.erb to job_description.erb
- add helpers.rb
	- add link_to helper
- format data returned by Reed Details API (remove [ and ]) -- error caused by app code, no format needed




