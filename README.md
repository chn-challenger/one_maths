# OneMaths

User stories:

```text
As a course maker
So that I can create courses for my students
I would like sign-up sign-in and sign-out
```

```text
As a course maker
So that students can learn from my course
I would like to create a course
```

```text
As a course maker
So that the course is structured according to curriculum
I would like to create different modules for a course
```

```text
As a course maker
So that I can use the same question in different lessons
I would like to create questions independent of lessons.
```

```text
As a course maker
So that I can reuse existing questions in new lessons
I would like to add a question from the database to a lesson
```

```text
As a student
So that I can check my work on a question
I would like to select a solution from a selection and see if my selection is correct or not
```

```text
As a student
So that I can see the model solution
I would like to see a model solution after submitting my answer choice
```

```text
As a student
So that I can record my progress
I would like for there be a record the results of questions attempted
```

```text
As a student
So that I judge my progress through the courses
I would like for there be levels of achievements based on my performance on questions
```

```text
As a course maker
So that I easily add a bran-new question to a lesson
I would like to add a question from lesson view which will be added to the lesson and the full list of questions
```

```text
Check model dependencies
```

New features / Issues
```text
Restrict access to create in controller level
```

```text
Database data migration
```

```text
Not logged in question order
```

```text
Running out of question for a student causes crash.
```

```text
Do not allow student to get next question if current question is not yet answered (table).
```

```text
Change the jquery to work on this rather than a class.
```

```text
Setup JS testing.
```

```text
Major feature:  Add leveling up criteria for lessons.
```

```text
Major feature: Screenshare / Online tuition.
```

```text
1. create copy of the current DB
pg_dump -F c -v -U postgres -h localhost <database_name> -f /tmp/<filename>.psql

2. drop db
rake db:drop

3. create db
rake db:create
(do not migrate)

4. restore db
pg_restore -c -C -F c -v -U <postgres> -d rails_two_development /tmp/<filename>.psql
```

```text
Rested exp, accul over 24 hours to a max.
```
