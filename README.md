# Timesheets

Please access the application at time1.cs5610f19.website

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Generate the seed data using `mix run priv/repo/seeds.exs`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
## Instructions
  * Use `mix run priv/repo/seeds.exs` to get the seed data
  * Jobs and users are pre loaded, find the credentials below
  * Sheets are not pre loaded.
  
## Attributions and References
* https://elixirforum.com/t/ecto-fields-validations/6081
* https://elixirforum.com/t/what-is-the-correct-way-to-use-ecto-query-that-allow-items-to-be-displayed-in-templates/7313
* https://elixirforum.com/t/nested-preload-from-the-doc-makes-me-confused/11991/5
* https://devhints.io
* https://getbootstrap.com/docs/
* elixir docs
* Phoenix docs
* Nats Notes (http://www.ccs.neu.edu/home/ntuck/courses/2019/09/cs5610/notes/) - mainly 12,13,15
* https://github.com/NatTuck/lens
* Preload examples from Elixir forums
* Other attributions mentioned in the code

## Design Decisions

* The maximum limit for one time sheet is 8 hours and a minimum of 1 hour needs to be logged in a sheet.
* User is allowed to submit multiple timesheets for one day and each sheet has a max limit of 8 hours
(Submitting multiple sheets was intended considering usual use cases. The rule of enforcing max 8 hours per sheet 
instead of a user for a date is that to make the application scalable in future)
* Time sheet can only be submitted for a past date. Cannot enter time for a date in future
* Only valid rows with filled hours and job code will be submitted and saved.
* Plugs are used to check for every controller if user is logged in
* All validations are done on the changeset in elixir side to meet assignment requirements.
* Only links relevant to the user are shown for the user. Even if attempted to access by directly entering will 
redirect with an error mentioning no permission.
* Fill new sheet is not shown to manager as for the scope of assignment we are considering manager not having manager
but did not limit this to make the application scalable later
* Manager will only see the jobs created by him
* A worker can log hours for any job created by any manager(usually for cross-functional development) but his sheet will
will be approved by reporting manager only
* Did not much of client side/js validations as mentioned in assignment
* Dates are considered as per UTC date for the assignment not the system date. This is to make the app validation/check
 unique which ever region server is hosted
* One job code can be submitted multiple times in the same form because the nature of work might differ
* Job code is selected as a string to support various cases(codes can be like NU5610 or combition or so)
* Database primary key is made false but again created as a field just to have the intention to modify it to make application 
scalable to full spec
* Routes related job edit and other actions are shown as their functionality is implemented. Other non used routes are removed
* Design decision was made to provide disapprove button which deletes the work log if manager decides to.
* Github commit id in status file is the one before last commit.
* Javascript is only used to warn user of partially entered i.e user selects job code but not hours or the reverse scenario.
This is to make sure that the user is aware of partial data and inform the user only completed rows are saved.

## Sample Data to login

Please use the following data to login and test the application
Managers
email: manager1@example.com  
password: passwordmanager1  
manages workers 1 to 5

email: manager2@example.com  
password: passwordmanager2  
manages workers 6,7

email: manager3@example.com  
password: passwordmanager3  
manages workers 8,9

Workers Format is as follows(number 1 to 9)
email: worker<number>@example.com
password: passwordworker<number>

For example worker 1
email: worker1@example.com  
password: passwordworker1

For example worker 3
email: worker3@example.com  
password: passwordworker3
