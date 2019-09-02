# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Video.create([{
               title: 'Monk',
               description: 'After the unsolved murder of his wife, Adrian Monk develops obsessive-compulsive disorder, which includes his terror of germs and contamination. His condition costs him his job as a prominent homicide detective in the San Francisco Police Department, but he continues to solve crimes with the help of his assistant and his former boss.',
               small_cover_url: 'videos/monk.jpg',
               category_id: 1
             },
              {
                title: 'Family Guy',
                description: 'Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family. Endearingly ignorant Peter and stay-at-home wife Lois reside in Quahog, R.I., and have three kids. Meg, the eldest child, is a social outcast, and teenage Chris is awkward and clueless when it comes to the opposite sex. The youngest, Stewie, is a genius baby bent on killing his mother and destroying the world. The talking dog, Brian, keeps Stewie in check while sipping martinis and sorting through his own life issues.',
                small_cover_url: 'videos/family_guy.jpg',
                category_id: 1
              },
              {
                title: 'South Park',
                description: 'The animated series is not for children. In fact, its goal seems to be to offend as many as possible as it presents the adventures of Stan, Kyle, Kenny and Cartman. The show has taken on Saddam Hussein, Osama bin Laden, politicians of every stripe and self-important celebrities. Oh, and Kenny is killed in many episodes.',
                small_cover_url: 'videos/south_park.jpg',
                category_id: 1
              },
              {
                title: 'Futurama',
                description: 'Accidentally frozen, pizza-deliverer Fry wakes up 1,000 years in the future. He is taken in by his sole descendant, an elderly and addled scientist who owns a small cargo delivery service. Among the other crew members are Capt. Leela, accountant Hermes, intern Amy, obnoxious robot Bender and lobsterlike moocher "Dr." Zoidberg.',
                small_cover_url: 'videos/futurama.jpg',
                category_id: 1
              }])

Category.create([{
                  name: 'TV Comedies'
                }, {
                  name: 'TV Dramas'
                }, {
                  name: 'Reality TV'
                }])
