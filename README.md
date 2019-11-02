# Timesheets

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Generate the seed data using `mix run priv/repo/seeds.exs`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
## Instructions
  * Use `mix run priv/repo/seeds.exs` to get the seed data
  
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
* Javascript is only used to warn user of partially entered i.e user selects job code but not hours or the reverse scenario.
This is to make sure that the user is aware of partial data and inform the user only completed rows are saved.