FactoryGirl.define do
  factory :question do
    question_text "question text #{rand(20)}"
    solution "solution #{rand(20)}"
    experience 100
    difficulty 1
  end
end
