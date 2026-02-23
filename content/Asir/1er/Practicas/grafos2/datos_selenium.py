from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
import time

def get_followers(driver):
    """
    Captura todos los nombres de los seguidores visibles en la ventana emergente.
    """
    # Encuentra todos los elementos <span> que contienen los nombres de seguidores
    follower_elements = driver.find_elements(By.XPATH, "//div[@role='dialog']//a/div/div/span")

    # Extrae el texto de cada elemento
    followers = [elem.text for elem in follower_elements if elem.text.strip()]
    return followers

# Configuración del driver
service = Service(r"C:\Program Files\chromedriver-win64\chromedriver.exe")
driver = webdriver.Chrome(service=service)

# lista = ["aleeegon11", "mateoselena04", "rdrigzzdm", "errrtonyyy", "_miiriiiam_", "ainh0a_24", "alvaroo_kx", "markkitos4", "elifluffli", "carlo.magnoo.07", "itxi_11", "portelita30", "andr3s_ds", "nuriuscan_", "caza_furciax24", "p4bler4s3_gsc", "danielito_jc", "_jeaime", "_.michipocho._", "diegomg_28", "hindi.28", "ainho015", "papis_upremo", "a.cns_", "diego_cmz31", "calaabazzin_08", "elisajg_10", "anadie.leimporta._", "joselitotlm", "davidyesoo", "irennealbiol", "albba.04", "paubalseiroo", "canelones_24", "manueljmnz_5", "lauritagnz_", "candelaagonzz", "mst4rx", "whoszowe", "itz.myt", "y.evvus", "friieda.ar", "febrerocmarina", "sintetizador_", "arxx.ha", "333aabi", "sara_ms131", "pabloluna.h", "yeenaislucy", "pabloluna.art", "yaiiza.gr__", "joeyy0007", "elpedruscofc", "ivaan_lora", "eh_olivia", "a.flpzz", "nicx15", "lule.flores", "sabs.floretes", "ablaro_24", "mportuondoo", "chiicaayeeyee", "vvale.mc", "inexiiitaa_crrb", "_ra.queeel", "jennntl", "ramonguzsam", "albagmmz", "mcaporilli06", "paaezzz__", "_carlaa5", "isantosssss", "paulaa_st_", "noaaa.no", "_.escribbanss", "vegaa.gc", "megustaelawaa", "samuucbh_", "riiggyy_", "rfhgh13", "roocio.veega", "derlis5141", "hectoormaartin", "aiitana_luengo", "aa.fr3sn", "mathaeus_s.i", "maario.ph_", "tere_maf", "payl.ott", "addrianaa.cg", "kandykandykaandy", "globi.__", "jesus__libano", "m4rkit0ss._", "_nahuelguzsil", "pailos_99", "3liassss_mdt", "pasalu_26", "maateo.ig", "_bruno_14_3_06", "guisoooooooo", "sara.garciiia_", "antoelqnopasalabola", "peree.13", "lukas_cj6", "maarinacuesta", "dieg0ter0", "lb.arc2005.bs", "alvaro_ardu", "mxxrcooss_", "mateo_r_z_", "notsilviacuesta", "asiier_25", "lyydiaa_26", "lydia_25_4", "k1000o.lion", "candela__camacho", "hectorf2005", "adrizul1610", "kawaii_tiomajo_28", "silviacuestaa", "paez_mdt"]
lista = ["_ra.queeel", "jennntl", "ramonguzsam", "albagmmz", "mcaporilli06", "paaezzz__", "_carlaa5", "isantosssss", "paulaa_st_", "noaaa.no", "_.escribbanss", "vegaa.gc", "megustaelawaa", "samuucbh_", "riiggyy_", "rfhgh13", "roocio.veega", "derlis5141", "hectoormaartin", "aiitana_luengo", "aa.fr3sn", "mathaeus_s.i", "maario.ph_", "tere_maf", "payl.ott", "addrianaa.cg", "kandykandykaandy", "globi.__", "jesus__libano", "m4rkit0ss._", "_nahuelguzsil", "pailos_99", "3liassss_mdt", "pasalu_26", "maateo.ig", "_bruno_14_3_06", "guisoooooooo", "sara.garciiia_", "antoelqnopasalabola", "peree.13", "lukas_cj6", "maarinacuesta", "dieg0ter0", "lb.arc2005.bs", "alvaro_ardu", "mxxrcooss_", "mateo_r_z_", "notsilviacuesta", "asiier_25", "lyydiaa_26", "lydia_25_4", "k1000o.lion", "candela__camacho", "hectorf2005"]

try:
    # Navegar a Instagram
    driver.get("https://www.instagram.com/accounts/login/")
    
    # Navegar al perfil
    for person in lista:
        
        input("Enter para seguir")
        
        driver.get(f"https://www.instagram.com/{person}/followers/")
        time.sleep(5)

        # Pausa para abrir la lista de seguidores manualmente
        input("Abre la lista de seguidores, desplázate al final y presiona Enter para continuar...")

        # Capturar seguidores visibles
        followers = get_followers(driver)
        print(f"Seguidores capturados ({len(followers)}):")
        
        with open("texto.txt", "a") as file:
            
            print(person + "\n")
            
            for follower in followers:
                print("---" + follower)
                
            file.write(person + ": " + ', '.join(followers) + "\n")
            
finally:
    # Cerrar el navegador
    driver.quit()
