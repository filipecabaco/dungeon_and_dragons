import Konva from "konva"
const Canvas = {
    mounted() {
        const user_id = this.el.getAttribute("user_id")
        const container = document.querySelector('#canvas');
        const stage = new Konva.Stage({
            container: 'canvas',
            draggable: true,
            width: container.offsetWidth,
            height: container.offsetHeight,
        });

        const mapLayer = new Konva.Layer()
        Konva.Image.fromURL('https://i0.wp.com/dnd-maps.com/wp-content/uploads/Encounter-1-9fc2c38b-scaled.jpg', (img) => {
            img.setAttrs({ scaleX: 1.5, scaleY: 1.5 })
            mapLayer.add(img)
        });

        const playerLayer = new Konva.Layer()
        this.handleEvent('new_user', ({ id, char, x, y }) => {
            Konva.Image.fromURL(`/images/chars/${char}`, (img) => {
                let attrs = { width: 85, height: 85, draggable: true, x, y, id }
                attrs = id == user_id ? { ...attrs, stroke: 'red', strokeWidth: 5, cornerRadius: 10 } : attrs

                img.setAttrs(attrs)

                img.on("dragstart", (evt) => { if (evt.target.attrs.id != user_id) { evt.target.stopDrag() } })
                img.on("dragmove", (evt) => {
                    let x = evt.target.attrs.x
                    let y = evt.target.attrs.y
                    this.pushEvent("update_movement", { user_id, x, y })
                })
                playerLayer.add(img)
            })

        })

        this.handleEvent('delete_user', ({ id }) => { stage.findOne(`#${id}`).destroy() })
        this.handleEvent('move_user', ({ id, x, y }) => {
            let elem = stage.findOne(`#${id}`)
            elem.setAttrs({ x, y })
        })

        stage.add(mapLayer)
        stage.add(playerLayer)
    }
}

export default Canvas