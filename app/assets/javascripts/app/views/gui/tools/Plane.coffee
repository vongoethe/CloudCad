S.export(
    "views/gui/tools/Plane",
    ["views/gui/tools/AbstractTool","views/draw/3D/primitives/Plane3D"],
    (AbstractTool,Plane3D)->
        class Plane extends AbstractTool

            constructor:->
                super()
                @icon = "border-all.png"
                @SM = {} #Selected Mesh
                
                # Register callback
                $(document).bind("execute_tool_Plane", =>
                    @do()
                )

            mouseDown:=>
                if @stage3d.layers.solids? and @stage3d.layers.planes?
                    c = @getMouseTarget([@stage3d.layers.solids,@stage3d.layers.planes,@stage3d.layers.originPlanes])
                else if @stage3d.layers.solids? and not @stage3d.layers.planes?
                    c = @getMouseTarget([@stage3d.layers.solids,@stage3d.layers.originPlanes])
                else if not @stage3d.layers.solids? and @stage3d.layers.planes?
                    c = @getMouseTarget([@stage3d.layers.planes,@stage3d.layers.originPlanes])
                else
                    c = @getMouseTarget(@stage3d.layers.originPlanes)
                if c? and c.length>0
                    if c[0].object? and c[0].face?
                        obj = c[0].object.father 
                        face = c[0].face
                        point = c[0].point
                        if obj.class == "Solid3D"
                            normal = face.normal
                            faceVertices = obj.facesWithNormal(face.normal,"vertex")
                            barycenter = @getBarycenter faceVertices

                            v = new THREE.Vector3()
                            v.add(barycenter,normal)

                            dummyObject = new THREE.Object3D()
                            dummyObject.position=barycenter
                            dummyObject.lookAt(v)
                            
                            normalizedVertices=[]
                            for vert in faceVertices
                                ve = new THREE.Vertex()
                                ve.position = vert.position.clone()
                                ve.position = ve.position.toObject(dummyObject)
                                normalizedVertices.push(ve)
                            
                            geo = new THREE.Geometry()
                            geo.vertices = normalizedVertices
                            geo.computeBoundingBox()
                            w = geo.boundingBox.max.x-geo.boundingBox.min.x
                            h = geo.boundingBox.max.y-geo.boundingBox.min.y

                            plane = new Plane3D(
                                position: barycenter
                                #rotation: dummyObject.rotation
                                size:
                                    w:Math.abs(w)+10
                                    h:Math.abs(h)+10
                                normalSize:Math.abs((w*2+h*2)/20)
                                color: 0xccaabb
                            )
                            #plane.verts = faceVertices
                            plane.lookAt(v)
                            obj.add plane
                            

            mouseDragged:=>


            mouseUp:=>
            

        # Singleton
        new Plane()
)
