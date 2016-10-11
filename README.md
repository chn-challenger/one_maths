[![Build Status](https://travis-ci.org/chn-challenger/one_maths.png)](https://travis-ci.org/chn-challenger/one_maths)
[![Coverage Status](https://coveralls.io/repos/github/chn-challenger/one_maths/badge.svg?branch=master)](https://coveralls.io/github/chn-challenger/one_maths?branch=master)
[![Code Climate](https://codeclimate.com/github/chn-challenger/one_maths/badges/gpa.svg)](https://codeclimate.com/github/chn-challenger/one_maths)

# OneMaths

[OneMaths Beta-live Site](http://138.68.139.152/)

[![Screen Shot 2016-10-06 at 12.34.17.png](https://s22.postimg.org/kt0ijzrdt/Screen_Shot_2016_10_06_at_12_34_17.png)](https://postimg.org/image/es2tmx4rh/)

# OneMaths
One Maths is an online maths learning website aimed at providing top quality tuition to UK students aged 11-18, helping students achieve exam success with minimum effort.  

- - -


### Contractor/Contributor Sought
We are currently looking for a contractor to carry out some of the below (and more) development work for us.  This is a paid position, pay depend on experience and can negotiate.  The contracting work can possibly lead to a permanent role in our startup.  We are currently a team of 3, and have secured funding for 2 years for a team of 4.  If you are interested, please drop me an email:  chn_challenger@hotmail.com

- - -


### Outline

Tuition is delivered via videos, which are voiced over latex maths presentations, uniform quality and meticulously prepared.  Students are asked to practice with exercise questions in order to achieve passing experience in individual lessons, and higher levels across the topic as a whole.  Our questions are designed in two groups.  The first group are lesson practice questions, which exhibit a high level of association with the lesson video examples learnt.  Students should be able to complete these questions with relative ease due to the high similarity to the lesson examples.  Full solution to a question is provided after student answered a question, using methods outlined in the video example.  Students should not struggle with this first group of practice questions, they are here to help reinforce the basic ideas.  The second group of questions are more challenging, these are placed at the end of each chapter.  This is where the student is increasingly challenged, less structure is given, more abstract use of the ideas are demanded.  In this second group, very detailed solutions are also provided upon completion of a question, thus allowing the student to understand at least one way in which the problem can be solved.

We are developing features to foster good habits for our students, and gamification features to keep them interested enough to complete the courses.  Currently implemented is a streak bonus system, students are encouraged to slow down and get things right the first time.  Each time a student completes a question successfully, streak-bonus is added for the next question in the lesson/chapter, which is a percentage of the question experience.  This can increase to a maximum of 100% after 5 consecutive correct answers.  The streak bonus is reset to 0 in event of a wrong solution.  We would like to also add a daily experience bonus to encourage students to do questions everyday, as well as many other gamification features to motivate students.

Eventually, our website should be an overpowered tutor replacement for vast majority of students who are looking for maths tuition outside of school.  We have yet to decide on a business model, one possibility is to offer subscription, together with 100% money back guarantee for minimum exam success, provided student completes our courses.

- - -

### Development Installation

Anyone interested in our project is welcome to download and play with our code.  To install for local development, need to

##### Step 1: Install Psql, PhantomJS and ImageMagick

Google the installations for these.

##### Step 2: Clone and bundle install gems

Google the installations for these.


##### Step 3: Create the databases and run migrations
Inside the project root directory, create the dev and test databases
```sh
rake db:create
```
Run migrations
```sh
rake db:migrate
rake db:migrate RAILS_ENV=test
```

##### Step 4: Start local server
Inside the project root directory, create the dev and test databases
```sh
rails s
```
Visit localhost in chrome
```sh
http://localhost:3000
```

##### Create an admin user who can add content
Visit localhost in chrome, Sign up as a new user, then start the rails console
```sh
rails c
```
Find the last user (your user)
```sh
admin = User.last
```
Set role to 'super_admin'
```sh
admin.role = 'super_admin'
admin.save
```
Now you can create course and other content while logged on as this user.

##### Create an student user
By default, all new users are assigned role of 'student'.

##### Create questions / question choice with image
You will need to either link the development app to your own AWS S3 account or remove the AWS gem so that the images are saved locally.

---

### New Features / Enhancements / Bugs

##### Feature - Daily Bonus Experience
```text
In order to encourage students to do some questions everyday, we like to implement a daily experience
bonus system.  A student will be able to accumulate upto say a maximum 50 exp points until they
start to use these, thus if they did not log on for 1 days, the bonus pool will be 50, same as
absent for 7 days.  These bonus points are added/used on a 1 to 1 basis whenever they next gain
experience normally by answering questions correctly next time they are online.  
```

##### Enhancement - Larger clickables for radio buttons
```text
Larger clickables for radio buttons for multiple choice questions
```

##### Enhancement - Cancancan settings
```text
Check all Cancancan settings, add more tests for these.
```

##### Enhancement - Devise User
```text
Extend the basic User model provided by Devise, such as field for first name, second name, avatar image.
Setup password recovery etc, the standard stuff.
```

##### Feature - Level Differentiated Questions for End of Chapter Questions
```text
End of chapter questions should be differentiating through difficulty level, amount of experience gained
should be adjusted according to level difference between the question and the student's current level
in the chapter.
```

##### Major Feature - Integrated Virtual Black Board
```text
Integrate virtual black board so that student and tutor can meet online and both have access to the black
board through the website.  The tutor will also have access to presentation decks for lessons which the
tutor can control and share with the student during the lesson.
```

##### Feature - Student Profile Dashboard
```text
Something appropriate to start with, useful and encourage statistics.  What is useful?  We have to do some validated testing.
```

#### Feature - Linear Equation Generator
```text
Integrate the linear equation question generator from /chn-challenger/project_maths as a lesson
question generator.  
```

##### Bug
```text
When the same question is added to two lessons, and when it has been answered in one lesson, it kept on
repeating itself in another lesson, it kept on reappearing.
```

##### Feature - Progress Test
```text
Compile progress test for students.
```

##### Feature - Question tags
```text
Add tags to questions so admin can filter by tags.
```

##### Feature - Admin resetting lesson and modifying experience
```text
Web tool for the above so that admin do not need to mess with production console to fix
such issues.
```

##### Feature - Home page
```text
The current homepage is not really our eventual homepage, which is still to be designed.
```

##### Possible Enhancement - Recycle incorrect questions once ran out
```text
More details of how many partial question experience points are gained.
```


##### Feature - Home page
```text
Ability to reset student answers and lessons
```
