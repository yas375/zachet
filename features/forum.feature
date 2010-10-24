Feature: Forums
  In order to manage forums
  As an admin
  I want to create a new forums

  Background:
    Given basic setup

  Scenario: Viewing forums index by anonym
    Given I am on the forum
    Then I should not see "Новый форум"

  Scenario: Viewing forums index by admin
    Given I am logged in as "admin" with the password "admin"
    When I go to the forum
    Then I should see "Новый форум"

  Scenario: Adding new forum and subforum
    Given I am logged in as "admin" with the password "admin"
    And I am on the forum
    When I follow "Новый форум"
    Then I should see "Новый форум"
    When I fill in the following:
     | forum[title]       | Сайт и форум |
     | forum[description] | Обсуждение сайта и форума |
    And press "Создать"
    When I go to the forum
    Then I should see "Сайт и форум"
    And I should see "Обсуждение сайта и форума"

    # creating subforum
    When I follow "Сайт и форум"
    Then I should see "Добавить подфорум"
    When I follow "Добавить подфорум"
    And I fill in the following:
     | forum[title]       | Новости                   |
     | forum[description] | Наши самые последние фичи |
    And press "Создать"

    # check subforum
    When I go to the forum
    And follow "Сайт и форум"
    Then I should see "Подфорумы"
    And I should see "Новости"
    And I should see "Наши самые последние фичи"
