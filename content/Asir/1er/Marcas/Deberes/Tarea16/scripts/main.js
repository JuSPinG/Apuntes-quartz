class Producto {
    constructor(url, precio, seccion, velocidad, uso, puerto) {
        this.url = url;
        this.precio = precio;
        this.seccion = seccion;
        this.velocidad = velocidad;
        this.uso = uso;
        this.puerto = puerto;
    }

    CrearLista(productos) {
        let lista = [];

        productos.forEach(i => {
            if(i.seccion == this.seccion) {
                lista.push(i);
            }
        });

        return lista;
    }

    CargarProductos(productos) {
        let productosCargar = this.CrearLista(productos);
        let tablas = Math.floor((productosCargar.length-1)/4)+1;
        console.log(productosCargar);
        console.log(tablas);
        let texto = "";

        for (let e = 0; e < tablas; e++) {

            let productosCargarTabla = productosCargar.slice(e*4, (e*4)+4)
            texto += "<table align='center'><tr>";

            // Sección TR1
            productosCargarTabla.forEach(i => {
                texto += `<td><img src="${i.url}" style="width: 300px;"></td>`;
            });

            texto += "<tr><tr>";

            // Sección TR2
            productosCargarTabla.forEach(i => {
                texto += `<td><h3>${i.precio} €</h3></td>`;
            });

            texto += "<tr>";

            // Sección TR3
            productosCargarTabla.forEach(i => {
                texto += `<td><h3>${i.velocidad}</h3></td>`;
            });

            texto += "<tr>";

            // Sección TR4
            productosCargarTabla.forEach(i => {
                texto += `<td><h3>${i.uso}</h3></td>`;
            });

            texto += "<tr>";

            // Sección TR5

            productosCargarTabla.forEach(i => {
                texto += `<td><h3>${i.puerto}</h3></td>`;
            });

            texto += "<tr></table>";
        }

        document.getElementById("productos").innerHTML = texto;
    }
}

let productos = [new Producto("../img/5.webp", 119.99, 0, "10 Gbps", "Empresarial", "PCIe"),
                new Producto("../img/6.webp", 130, 0, "10 Gbps", "Empresarial", "PCIe"),
                new Producto("../img/15.webp", 75, 0, "1 Gbps", "Empresarial", "PCIe"),
                new Producto("../img/16.png", 300, 0, "25 Gbps", "Empresarial", "PCIe"),
                //Fibra SAN
                new Producto("../img/1.webp", 150, 1, "8 Gbps", "Empresarial", "PCIe"),
                new Producto("../img/2.webp", 225, 1, "16 Gbps", "Empresarial", "PCIe"),
                new Producto("../img/3.webp", 700, 1, "64 Gbps", "Empresarial", "PCIe"),
                new Producto("../img/4.png", 420.99, 1, "32 Gbps", "Empresarial", "PCIe"),
                //Fibra Ethernet    
                new Producto("../img/7.png", 30, 2, "1 Gbps", "Empresarial", "PCIe"),
                new Producto("../img/8.png", 150, 2, "10 Gbps", "Empresarial", "PCIe"),
                new Producto("../img/9.png", 70, 2, "2.5 Gbps", "Doméstico", "PCIe"),
                new Producto("../img/10.png", 55, 2, "1 Gbps", "Doméstico", "PCIe"),
                //Tarjeta WiFi
                new Producto("../img/11.png", 135, 3, "10 Gbps", "Doméstico", "PCIe"),
                new Producto("../img/12.png", 78.99, 3, "5.8 Gbps", "Doméstico", "PCIe"),
                new Producto("../img/13.webp", 27, 3, "600 Mbps", "Doméstico", "PCIe"),
                new Producto("../img/14.png", 55, 3, "1.3 Gbps", "Doméstico", "PCIe")]


for (let i = 0; i < localStorage.length; i++) {
    console.log(1111);
    if (localStorage.key(i).startsWith("Producto: ")) {
        let producto = localStorage.getItem(localStorage.key(i))
        producto = producto.split(",");
        productos.push(new Producto(producto[0], producto[1], producto[3], producto[2], producto[4], producto[5]))
    }
}

function NuevoProducto(url, precio, seccion, velocidad, uso, puerto) {
    localStorage.setItem("Producto: " + productos.length, [url, precio, seccion, velocidad, uso, puerto]);
}
                
function getValue(name) {
    return decodeURIComponent(window.location.search.replace(new RegExp("^(?:.*[&\\?]" + encodeURIComponent(name).replace(/[\.\+\*]/g, "\\$&") + "(?:\\=([^&]*))?)?.*$", "i"), "$1"));
}

function main(num) {
    productos[num*4].CargarProductos(productos)
}