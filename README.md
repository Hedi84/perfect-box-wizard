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

To keep the controllers focused on HTTP concerns, I moved the workflow logic into an `OnboardingWizard` service object. The controller is responsible for receiving requests and rendering responses, while the service object coordinates validation, persistence and progression through the wizard.

For similar reasons, recipe matching lives inside a dedicated query object. This keeps the controller lean and gives the matching logic a single, well-defined responsibility.

In a larger production application I would likely consider using the Wicked gem or dedicated form objects, depending on the complexity of the workflow.

I have worked on a large legacy application where the wizard logic was split across many models, form models and controllers. Although this approach is flexible, it can make the flow difficult to understand for developers who are new to the codebase. Adding a feature often requires changes in multiple places, which increases the risk of unintentionally affecting existing behaviour.

For this challenge I intentionally chose a simpler architecture. Contextual model validations provide the behaviour required for a three-step wizard without introducing unnecessary complexity, while still keeping responsibilities clearly separated.

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
