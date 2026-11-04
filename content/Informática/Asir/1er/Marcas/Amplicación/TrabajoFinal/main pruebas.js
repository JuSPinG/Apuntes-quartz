const config = {
	type: Phaser.AUTO,
	width: window.innerWidth,
	height: window.innerHeight,
	scene: {
		preload: preload,
		create: create,
		update: update
	},
	backgroundColor: "#2d2d2d",
	input: {
		activePointers: 3,
		mouse: true,    // Necesario para desktop
		touch: true     // Necesario para móviles
	}
};

const game = new Phaser.Game(config);

function preload() {
	this.load.image("Montanna", "img/Montanna.png");
	this.load.image("Bosque", "img/Bosque.png");
	this.load.image("Desierto", "img/Desierto.png");
	this.load.image("Mar", "img/Mar.png");

}

function create() {
	var via1 = this.add.image(75, 375, 'Mar');
	via1.setScale(0.1); // Por ejemplo

    /*via1.on('pointerdown', (pointer) => {
        alert(88);
    });*/
    via1.setInteractive();

	var via2 = this.add.image(200, 375, 'Bosque');
	via2.setScale(0.1); // Por ejemplo

    /*via2.on('pointerdown', (pointer) => {
        alert(81);
    });*/
    via2.setInteractive();

	let vector = [via1, via2];

	vector.forEach(element => {
		element.on("pointerdown", (pointer) => {
			alert(1);
		})
	});
}

function update() {
}