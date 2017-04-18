## General Utilities

#### Gneral Queries
* Search for questions via TAG and update experience:
  ```ruby
  Tag.find_by(name: 'UC273807').questions.each { |q| q.update(experience: 40) }
  ```
* Search for duplicate Answered Questions with same user_id and question_id:
  ```ruby
  AnsweredQuestion.select(:user_id, :question_id).group(:user_id, :question_id).having("count(*) > 1")
  ```
* Search for duplicate Current Questions with same user_id and lesson_id:
  ```ruby
  CurrentQuestion.select(:user_id, :lesson_id).group(:user_id, :lesson_id).having("count(*) > 1")
  ```

#### Server Utilities
* Download file from local machine via `scp`:
```bash
scp <USER>@<SERVER_IP>:<PATH_TO_FILE> <LOCAL_DIRECTORY>  
```
* To create and download databse dump from production server run `rake db:pull` current_data.psql will be saved in current folder (for more details refer to `lib/tasks/db_pull.rake`)
