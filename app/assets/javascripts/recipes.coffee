# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class @Recipes

  # java script test for this code suck. Still experimenting with how to deal with JS tests
  # TODO: make this sort of test better. expected results TRUE or FALSE
  checkLoadMoreItems: ->
    load_more = document.getElementById('load-more-recipes')
    return if load_more == null
    window_size = window.innerHeight
    scroll_position = window.pageYOffset
    load_more_postion = load_more.offsetTop
    bottom = scroll_position + window_size
    bottom >= load_more_postion && load_more.dataset.loadingInProgress != 'true'

  removeCurrentLoadingMore: ->
    document.getElementById('load-more-recipes').remove()

  appendRecipeToTable: (row) ->
    table_body = document.getElementById('table-recipes-body')
    table_body.insertAdjacentHTML('beforeend', row)

  loadMore: ->
    load_more_recipes = document.getElementById('load-more-recipes')
    query = document.getElementById('recipe_query').value
    load_more_recipes.dataset.loadingInProgress = 'true'
    $.ajax
      url: '/recipes'
      dataType: 'script'
      data:
        recipe:
          query: query
          page: load_more_recipes.dataset.page


document.addEventListener "turbolinks:load", ->
  if new Recipes().checkLoadMoreItems()
    new Recipes().loadMore()
$(document).on 'scroll', ->
  if new Recipes().checkLoadMoreItems()
    new Recipes().loadMore()

