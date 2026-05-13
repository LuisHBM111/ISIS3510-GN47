from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd

app = FastAPI(title="Campus Navigation API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------------------------------
# Data loading
# ---------------------------------------------------------------------------

_buildings_df = pd.read_excel("edificios_y_casas.xlsx")

# ---------------------------------------------------------------------------
# Category and icon per building code
# ---------------------------------------------------------------------------

BUILDING_CATEGORY: dict[str, str] = {
    "ML": "academic", "B": "academic", "R": "academic", "O": "academic",
    "AU": "academic", "A": "academic", "W": "academic", "Q": "academic",
    "S": "academic",  "S1": "academic", "S2": "academic", "T": "academic",
    "Tm": "academic", "K": "academic", "K2": "academic", "K1": "academic",
    "L": "academic",  "H": "academic", "J": "academic", "M": "academic",
    "M1": "academic", "P": "academic", "P1": "academic", "G/Gb": "academic",
    "Sd": "academic", "LL": "academic", "Tx": "academic", "C": "academic",
    "Cc": "academic", "V": "academic",  "Y": "academic", "Cj": "academic",
    "Inv": "academic","Cp": "academic",
    "Ga": "sports",
    "RGA": "library", "Rgb": "library", "Rga": "library",
    "F": "library",   "U": "library",
    "Z": "food", "N": "food", "X": "food", "AF": "food", "SUD": "food",
    "Mj": "admin",   "Rgc": "admin",  "Ña": "admin",  "Ñb/Ñd": "admin",
    "Ñf": "admin",   "Ñg": "admin",   "Ñh": "admin",  "Ñi": "admin",
    "Ñj": "admin",   "Ñk": "admin",   "Ñl": "admin",  "Ñn": "admin",
    "Ño": "admin",   "Ñv": "admin",   "Ch": "admin",  "La": "admin",
    "Lp": "admin",   "Ts": "admin",   "Pu": "admin",  "Es": "admin",
    "Ca": "admin",   "Ci": "admin",   "E": "admin",   "Fe01": "admin",
    "Fe02": "admin", "Fe03": "admin", "Br": "admin",  "Sm": "admin",
    "C22": "admin",  "Ss": "academic",
}

BUILDING_ICON: dict[str, str] = {
    "Ga":  "figure.run",
    "RGA": "books.vertical.fill", "Rgb": "books.vertical.fill",
    "Rga": "books.vertical.fill", "F":   "books.vertical.fill",
    "U":   "books.vertical.fill",
    "Z": "fork.knife", "N": "fork.knife", "X": "fork.knife",
    "AF": "fork.knife", "SUD": "fork.knife",
}

# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------

@app.get("/api/v1/buildings")
def get_buildings():
    """Return all campus buildings that have GPS coordinates in the Excel."""
    results = []
    for _, row in _buildings_df.iterrows():
        lat = row.get("Latitud")
        lon = row.get("Longitud")
        if pd.isna(lat) or pd.isna(lon):
            continue  # skip buildings without coordinates yet
        code = str(row["Codigo"]).strip()
        results.append({
            "id":          code,
            "name":        str(row["Edificio"]).strip(),
            "shortName":   code,
            "latitude":    float(lat),
            "longitude":   float(lon),
            "category":    BUILDING_CATEGORY.get(code, "academic"),
            "description": str(row["Ubicacion"]).strip(),
            "icon":        BUILDING_ICON.get(code, "building.fill"),
        })
    return results


@app.get("/health")
def health():
    return {"status": "ok"}
