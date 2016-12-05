require 'rails_helper'
require 'general_helpers'

describe Lesson, type: :model do
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic, 1, 'Published' }
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }
  let!(:question_1){create_question(1)}
  let!(:choice_1){create_choice(question_1,1,false)}
  let!(:choice_2){create_choice(question_1,2,true)}
  let!(:question_2){create_question(2)}
  let!(:choice_3){create_choice(question_2,3,false)}
  let!(:choice_4){create_choice(question_2,4,true)}
  let!(:question_3){create_question(3)}
  let!(:choice_5){create_choice(question_3,5,false)}
  let!(:choice_6){create_choice(question_3,6,true)}

  let!(:question_16){create_question_with_order(16,"c1")}
  let!(:answer_16){create_answer(question_16,16)}
  let!(:question_15){create_question_with_order(15,"e1")}
  let!(:answer_15){create_answer(question_15,15)}
  let!(:question_12){create_question_with_order(12,"z1")}
  let!(:answer_12){create_answer(question_12,12)}
  let!(:question_11){create_question_with_order(11,"d1")}
  let!(:answer_11){create_answer(question_11,11)}
  let!(:question_14){create_question_with_order(14,"d1")}
  let!(:answer_14){create_answer(question_14,14)}
  let!(:question_13){create_question_with_order(13,"b1")}
  let!(:answer_13){create_answer(question_13,13)}

  let!(:question_21){create_question_with_order(21,"c1")}
  let!(:answer_21){create_answer(question_21,21)}
  let!(:question_22){create_question_with_order(22,"e1")}
  let!(:answer_22){create_answer(question_22,22)}
  let!(:question_23){create_question_with_order(23,"e1")}
  let!(:answer_23){create_answer(question_23,23)}
  let!(:question_24){create_question_with_order(24,"d1")}
  let!(:answer_24){create_answer(question_24,24)}
  let!(:question_25){create_question_with_order(25,"b1")}
  let!(:answer_25){create_answer(question_25,25)}
  let!(:question_26){create_question_with_order(26,"z1")}
  let!(:answer_26){create_answer(question_26,26)}

  let!(:question_31){create_question_with_order_exp(31,"a1",10)}
  let!(:question_32){create_question_with_order_exp(32,"a1",20)}
  let!(:question_33){create_question_with_order_exp(33,"b1",50)}
  let!(:question_34){create_question_with_order_exp(34,"b1",60)}
  let!(:question_35){create_question_with_order_exp(35,"b1",70)}
  let!(:question_36){create_question_with_order_exp(36,"c1",80)}
  let!(:question_37){create_question_with_order_exp(37,"d1",25)}
  let!(:question_38){create_question_with_order_exp(38,"d1",30)}
  let!(:question_39){create_question_with_order_exp(39,"d1",20)}
  let!(:question_40){create_question_with_order_exp(40,"d1",10)}

  let!(:question_41){create_question_with_order_exp(41,"e1",100)}
  let!(:question_42){create_question_with_order_exp(42,"f1",100)}
  let!(:question_43){create_question_with_order_exp(43,"g1",100)}
  let!(:question_44){create_question_with_order_exp(44,"h1",100)}
  let!(:question_45){create_question_with_order_exp(45,"i1",100)}
  let!(:question_46){create_question_with_order_exp(46,"j1",100)}



  describe '#recommend_pass_exp' do
    it 'set passing exp eg 1' do
      lesson.questions = [question_31,question_32,question_33,question_34]
      lesson.save
      expect(lesson.recommend_pass_exp).to eq 84
    end

    it 'set passing exp eg 2' do
      lesson.questions = [question_31]
      lesson.save
      expect(lesson.recommend_pass_exp).to eq 10
    end

    it 'set passing exp eg 3' do
      lesson.questions = [question_37,question_38,question_39]
      lesson.save
      expect(lesson.recommend_pass_exp).to eq 25
    end

    it 'set passing exp eg 4' do
      lesson.questions = [question_37,question_38,question_39,question_34,
        question_35,question_36]
      lesson.save
      expect(lesson.recommend_pass_exp).to eq 203
    end

    it 'set passing exp eg 5' do
      lesson.questions = [question_37,question_38,question_40]
      lesson.save
      expect(lesson.recommend_pass_exp).to eq 22
    end

    it 'set passing exp eg 6' do
      lesson.questions = [question_41,question_42,question_43,question_44,question_45,question_46]
      lesson.save
      expect(lesson.recommend_pass_exp).to eq 950
    end
  end

  describe '#question_orders' do
    it 'returns an array of ordered question orders' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      expect(lesson.question_orders).to eq ["b1", "c1", "d1", "e1", "z1"]
    end
  end

  describe '#question_by_order' do
    it 'returns an array of 1 questions of the same order' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      expect(lesson.questions_by_order("e1")).to eq [question_15].sort
    end

    it 'returns an array of 2 questions of the same order' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      expect(lesson.questions_by_order("d1")).to eq [question_11,question_14].sort
    end
  end

  describe '#next_question_order' do
    it 'returns the first order if no question has been answered' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      expect(lesson.next_question_order(student)).to eq "b1"
    end

    it 'returns the order of the next question based on last answered question 1' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: true)
      expect(lesson.next_question_order(student)).to eq "e1"
    end

    it 'returns the order of the next question based on last answered question 2' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      expect(lesson.next_question_order(student)).to eq "d1"
    end

    it 'returns the order of the next question based on last answered question 3' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      expect(lesson.next_question_order(student)).to eq "c1"
    end

    it 'returns the order of the next question based on last answered question 4' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: true)
      expect(lesson.next_question_order(student)).to eq "d1"
    end

    it 'returns the order of the next question based on last answered question 5' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      expect(lesson.next_question_order(student)).to eq "z1"
    end

    it 'returns the order of the next question based on last answered question 6' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: true)
      expect(lesson.next_question_order(student)).to eq "b1"
    end
  end

  describe '#available_next_question_order' do
    it 'return next available order for which there is a question 1' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: true)
      preliminary_next_order = lesson.next_question_order(student)
      expect(lesson.available_next_question_order(preliminary_next_order,student)).to eq 'e1'
    end

    it 'return next available order for which there is a question 2' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: true)
      preliminary_next_order = lesson.next_question_order(student)
      expect(lesson.available_next_question_order(preliminary_next_order,student)).to eq nil
    end

    it 'return next available order for which there is a question 3' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: true)
      preliminary_next_order = lesson.next_question_order(student)
      expect(lesson.available_next_question_order(preliminary_next_order,student)).to eq "e1"
    end

    it 'return next available order for which there is a question 4' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_21.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_25.id, lesson_id:lesson.id, correct: true)
      preliminary_next_order = lesson.next_question_order(student)
      expect(lesson.available_next_question_order(preliminary_next_order,student)).to eq "d1"
    end

    it 'return next available order for which there is a question 5' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_26.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: true)
      preliminary_next_order = lesson.next_question_order(student)
      expect(lesson.available_next_question_order(preliminary_next_order,student)).to eq "b1"
    end

    it 'return next available order for which there is a question 6' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_26.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      preliminary_next_order = lesson.next_question_order(student)
      expect(lesson.available_next_question_order(preliminary_next_order,student)).to eq "d1"
    end

    it 'return next available order for which there is a question 7' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_26.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_24.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      preliminary_next_order = lesson.next_question_order(student)
      expect(lesson.available_next_question_order(preliminary_next_order,student)).to eq "b1"
    end
  end

  describe '#get_next_question_of' do
    it 'returns the next question of a given order at random 1' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      expect(lesson.get_next_question_of("d1",student)).to eq question_14
    end

    it 'returns the next question of a given order at random 2' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      expect(lesson.get_next_question_of("z1",student)).to eq nil
    end

    it 'returns the next question of a given order at random 3' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      srand(100)
      expect(lesson.get_next_question_of("d1",student)).to eq question_11
      srand(101)
      expect(lesson.get_next_question_of("d1",student)).to eq question_14
    end
  end

  describe '#random_question' do
    it 'random pick question of same order after getting one wrong' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      expect(lesson.random_question(student)).to eq question_26
    end

    it 'random pick question of after getting one right' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: true)
      srand(100)
      expect(lesson.random_question(student)).to eq question_15
      srand(101)
      expect(lesson.random_question(student)).to eq question_22
      srand(106)
      expect(lesson.random_question(student)).to eq question_23
    end

    it 'random pick question of after getting one right and jump 1 lot' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_24.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: true)
      srand(100)
      expect(lesson.random_question(student)).to eq question_15
      srand(101)
      expect(lesson.random_question(student)).to eq question_22
      srand(106)
      expect(lesson.random_question(student)).to eq question_23
    end

    it 'random pick question of after getting one wrong and jump 1 lot' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_21.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      expect(lesson.random_question(student)).to eq question_24
    end

    it 'random pick question of after getting one right and jump 2 lot' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_24.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: true)
      srand(100)
      expect(lesson.random_question(student)).to eq question_12
      srand(101)
      expect(lesson.random_question(student)).to eq question_26
    end

    it 'random pick question of after getting one wrong and jump 2 lot' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_24.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      srand(100)
      expect(lesson.random_question(student)).to eq question_12
      srand(101)
      expect(lesson.random_question(student)).to eq question_26
    end

    it 'random pick question of after getting one right and jump 3 lot with reset' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_26.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: true)
      srand(100)
      expect(lesson.random_question(student)).to eq question_13
      srand(101)
      expect(lesson.random_question(student)).to eq question_25
    end

    it 'random pick question of after getting one wrong and jump 3 lot with reset' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_26.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: true)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      srand(100)
      expect(lesson.random_question(student)).to eq question_13
      srand(101)
      expect(lesson.random_question(student)).to eq question_25
    end

    it 'returns to same order after one wrong with a whole loop' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_21.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_24.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_25.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_26.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: false)
      expect(lesson.random_question(student)).to eq question_11
    end

    it 'returns nil if all questios are answered' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_21.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_24.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_25.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_26.id, lesson_id:lesson.id, correct: false)
      expect(lesson.random_question(student)).to eq nil
    end
  end
end
