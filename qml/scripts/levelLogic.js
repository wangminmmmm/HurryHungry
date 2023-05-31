
var newRoostCenterPos = Qt.point(0,0)
var randomValue
var coinCenterPos = Qt.point(0,0)
var coinPositionModifier = 0.7*scene.gridSize
var gridSizeHalf = scene.gridSize/2
var newWindowTopleftPos = Qt.point(0,0)
var roostUrl = Qt.resolvedUrl("../entities/Support.qml")
var coinUrl = Qt.resolvedUrl("../entities/Bread.qml")

var newElementProperties = {}

function createRandomRowForRowNumber(rowNumber) {
    for(var i=0; i<roostColumns; i++) {

        randomValue = Math.random()
        if(randomValue < platformCreationProbability ) {


            newRoostCenterPos.x = i*gridSize + gridSizeHalf
            newRoostCenterPos.y = rowNumber*gridSize + gridSizeHalf

            if(physicsWorld.bodyAt(newRoostCenterPos)) {
                console.debug("no Roost can be created because there is a window already");
                continue;
            }

            console.debug("creating a new Roost at position", i*gridSize + gridSize/2, ",", rowNumber*gridSize + gridSize/2);


            newElementProperties.x = newRoostCenterPos.x
            newElementProperties.y = newRoostCenterPos.y
            entityManager.createEntityFromUrlWithProperties(roostUrl,newElementProperties)

            randomValue = Math.random()
            if(randomValue < coinCreationPropability) {

                coinCenterPos.x = newRoostCenterPos.x
                coinCenterPos.y = newRoostCenterPos.y-scene.gridSize

                if(physicsWorld.bodyAt(coinCenterPos)) {
                    console.debug("there is a block above the to create block, don't create a coin here!")
                    continue;
                }


                newElementProperties.x = coinCenterPos.x
                newElementProperties.y = coinCenterPos.y+coinPositionModifier
                entityManager.createEntityFromUrlWithProperties(coinUrl,newElementProperties)
            }
        } else if(i < roostColumns-1 && randomValue < windowCreationProbability ) {



            newWindowTopleftPos.x = i*gridSize
            newWindowTopleftPos.y = rowNumber*gridSize

            console.debug("newWindowTopleftPos.y-lastWindowY:", newWindowTopleftPos.y-lastWindowY)

            if(newWindowTopleftPos.y-lastWindowY < minimumWindowHeightDifference) {
                console.debug("difference between last Window and current to create one too small!")
                continue;
            }

            if(physicsWorld.bodyAt(newWindowTopleftPos)) {
                console.debug("body at position x:", newWindowTopleftPos.x, ", y:", newWindowTopleftPos.y, physicsWorld.bodyAt(newWindowTopleftPos))
                console.debug("there is a window at the position where to create a window, so no creation is done");
                continue;
            }

            newElementProperties.x = newWindowTopleftPos.x
            newElementProperties.y = newWindowTopleftPos.y
            newElementProperties.z = 0
            entityManager.createEntityFromUrlWithProperties(windowUrl,newElementProperties)

            lastWindowY = newWindowTopleftPos.y;
        }

    }
}
