import Konva from "konva"
const mapUrl = "https://i0.wp.com/dnd-maps.com/wp-content/uploads/Encounter-1-9fc2c38b-scaled.jpg"
const Canvas = {
    mounted() { draw(this) },
    reconnected() { draw(this) }
}

function draw(hook) {
    const user_id = hook.el.getAttribute("user_id")
    const container = document.querySelector('#canvas');
    const stage = new Konva.Stage({ container: 'canvas', draggable: true, width: container.offsetWidth, height: container.offsetHeight, });
    const mapLayer = new Konva.Layer()
    const playerLayer = new Konva.Layer()

    Konva.Image.fromURL(mapUrl, (img) => { mapLayer.add(img) });
    stage.add(mapLayer)
    stage.add(playerLayer)

    hook.handleEvent('new_user', ({ id, char, x, y }) => {
        Konva.Image.fromURL(`/images/chars/${char}`, (img) => {
            let attrs = { width: 60, height: 60, draggable: true, x, y, id }
            attrs = id == user_id ? { ...attrs, stroke: 'red', strokeWidth: 5 } : attrs
            img.setAttrs(attrs)
            playerLayer.add(img)

            img.on("dragstart", ({ target }) => {
                if (target.attrs.id != user_id) { target.stopDrag() }
            })
            img.on("dragmove", ({ target: { attrs: { x, y } } }) => {
                hook.pushEvent("update_movement", { user_id, x, y })
            })
        })
    })
    hook.handleEvent('delete_user', ({ id }) => { stage.findOne(`#${id}`).destroy() })
    hook.handleEvent('move_user', ({ id, x, y }) => { stage.findOne(`#${id}`).setAttrs({ x, y }) })

    return stage
}

export default Canvas