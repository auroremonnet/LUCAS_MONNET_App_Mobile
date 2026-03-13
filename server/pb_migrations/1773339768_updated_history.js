/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_3068727201")

  // update collection data
  unmarshal({
    "createRule": "@request.auth.id != \"\" && user.id = @request.auth.id",
    "deleteRule": "user.id = @request.auth.id",
    "listRule": "user.id = @request.auth.id",
    "updateRule": "user.id = @request.auth.id",
    "viewRule": "user.id = @request.auth.id"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_3068727201")

  // update collection data
  unmarshal({
    "createRule": "",
    "deleteRule": "",
    "listRule": null,
    "updateRule": "",
    "viewRule": ""
  }, collection)

  return app.save(collection)
})
