import QtQuick 2.0

import Felgo 3.0


EntityBase {
  id: entity
  entityType: "borderRegion"
  variationType: "topRegion"

  signal playerCollision

  preventFromRemovalFromEntityManager: true

  BoxCollider {
    id: boxCollider
    bodyType: Body.Dynamic
    collisionTestingOnlyMode: true

    fixture.onBeginContact: {

      var fixture = other;
      var body = other.getBody();
      var collidedEntity = body.target;
      var collidedEntityType = collidedEntity.entityType;

      console.debug("BorderRegion: collided with entity type:", collidedEntityType);

      if(collidedEntityType === "player")
        entity.playerCollision();
      else {
        if(variationType === "bottomRegion")
          return;

        if(collidedEntity.entityId === "playerInitialBlock")
          return;

        collidedEntity.removeEntity();
      }
    }
  }
}
