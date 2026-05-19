

pub enum Cloth{
  NikkiGeneral{
    id: i64,
    outfit: i64,
    species: ClothSpecies,
    cloth_type: ClothType,
    state: ClothState,
  },
  NikkiAccessories{
    id: i64,
    outfit: i64,
    species: ClothSpecies,
    cloth_type: ClothType,
    state: ClothState,
  },
  NikkiMakeup{
    id: i64,
    outfit: i64,
    makeup: i64,
    species: ClothSpecies,
    cloth_type: ClothType,
    state: ClothState,
  },
  Momo{
    id: i64,
    species: ClothSpecies,
    cloth_type: ClothType,
    state: ClothState,
  },
}

pub enum ClothSpecies{
  Nikki = 102,
  Momo = 116,
}

pub enum ClothState{
  Evolution0 = 0,
  Value1 = 1,
  GlowUp = 2,
  Evolution1 = 3,
  Evolution2 = 4,
  Evolution3 = 5,
  Value6 = 6,
  Value8 = 8,
  Value9 = 9,
}

pub enum ClothSlot{
  Outfits,
  Hair,
  Dresses,
  Outerwear,
  Tops,
  Bottoms,
  Socks,
  Shoes,
  Accessories,
  Makeup,
}

pub enum ClothType{
  Hair = 10,
  Dresses = 90,
  Outerwear = 20,
  Tops = 30,
  Bottoms = 41,
  Socks = 50,
  Shoes = 60,
  HairAccessories = 71,
  Headwear = 72,
  Earrings = 73,
  Neckwear = 74,
  Bracelets = 75,
  Chokers = 76,
  Gloves = 77,
  FaceDecorations = 92,
  ChestAccessories = 93,
  Pendants = 94,
  Backpieces = 95,
  Rings = 96,
  ArmDecorations = 97,
  Handhelds = 78,
  BodyPaint = 79,
  FullMakeup = 80,
  BaseMakeup = 81,
  Eyebrows = 82,
  Eyelashes = 83,
  Contacts = 84,
  Lips = 85,
  SkinTones = 86,
}