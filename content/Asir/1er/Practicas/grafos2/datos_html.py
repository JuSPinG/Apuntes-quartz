from lxml import etree

# Cargar el archivo HTML
with open("1.html", "r", encoding="utf-8") as file:
    html_content = file.read()

# Parsear el contenido HTML
tree = etree.HTML(html_content)

# Usar XPath para extraer los enlaces
results = tree.xpath("//div[@role='dialog']//a/div/div/span")  # Cambia la expresión XPath según sea necesario

followers = [element.text for element in results]
profile = [element.text for element in tree.xpath("/html/body/div[2]/div/div/div/div[2]/div/div/div[1]/div[2]/div/div[1]/section/main/div/header/section[2]/div/div/div[1]/div/a/h2/span")][0]

print(profile)

with open("texto2.txt", "a") as file:
    file.write("\n")
    file.write(profile + ": " + ", ".join(followers))