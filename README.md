# Perfect Box Wizard

A Ruby on Rails 8 application demonstrating a multi-step onboarding wizard for a fictional subscription box service.

The application allows users to create an account, complete a three-step onboarding process, resume an incomplete onboarding, view a summary of their selections, and receive recipe recommendations based on their dietary preferences. An admin dashboard is also included to view completed and incomplete onboardings.

A live version of the application can be viewed at:

**<Render URL>**

## Tech Stack

* Ruby 3.3.4
* Rails 8.1.3
* SQLite (development & test)
* PostgreSQL (production)
* RSpec
* Stimulus

## Running the application

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/dev
```

The application will be available at:

```
http://localhost:3000
```

The seed data includes users at various stages of onboarding, plus an admin account for viewing the admin dashboard:

```
admin@example.com / password123
```

## Running the test suite

```bash
bundle exec rspec
```

---

# Design Decisions

## Wizard architecture

I wanted to keep the controllers focused on handling requests and responses, so I moved the wizard workflow into an OnboardingWizard service object. The service is responsible for validating each step, persisting the submitted data, and progressing the user through the onboarding journey.

For similar reasons, recipe matching lives in its own query object. This keeps the matching logic separate from the controller and gives it a single, well-defined responsibility.

In a larger production application, I would consider using the Wicked gem or dedicated form objects, depending on the complexity of the workflow. For this challenge, I felt that would introduce unnecessary complexity. A single Onboarding model with contextual validations, persisted progress, and a completed_at timestamp provides all the functionality required while keeping the implementation straightforward and easy to follow.

This decision was also influenced by previous experience working on a large legacy application with a highly complex form wizard. While that architecture was very flexible, the wizard logic was spread across numerous models, form models and controllers, making it difficult for new developers to understand the flow. Adding new functionality often required changes in several different places, increasing the likelihood of introducing regressions. For a small three-step wizard like this, I believe a simpler approach is easier to understand, maintain and extend.

## Persisting onboarding progress

The onboarding state is stored in the database rather than the session. This allows users to leave the application and continue where they left off after signing in again.

The `completed_at` column clearly indicates whether an onboarding has been finished and would allow the application to query incomplete onboardings or trigger follow-up actions, such as reminder emails after a certain period of inactivity.

The `current_step` column stores the user's progress through the wizard.

Currently, progressing backwards updates the stored step as well. This was a conscious design decision. Changes made earlier in the journey may reasonably affect later decisions. For example, changing the delivery address could influence delivery preferences, or changing dietary preferences could affect the recommended recipes shown at the end of the flow.

Depending on business requirements, an alternative implementation could instead remember the furthest completed step while still allowing users to revisit earlier pages.

---

# Testing

The application includes a combination of unit and integration tests.

Current coverage includes:

* Model validations
* Service object behaviour
* Query object behaviour
* Request specs covering wizard progression
* A feature spec covering the complete customer onboarding journey (happy path)

With more time, I would extend the feature coverage to include the admin interface and additional unhappy-path scenarios, such as validation errors and edge cases.

---

# Future Improvements

If I had more time, I would consider implementing:

* Allow users to edit their onboarding after completion.
* Additional feature specs covering the admin dashboard and validation failures.
* Improved accessibility and UI polish.
* Email reminders for incomplete onboardings.
* More comprehensive authorisation for admin functionality.
