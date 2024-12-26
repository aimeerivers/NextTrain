//
//  Stations.swift
//  NextTrain
//
//  Created by aimee rivers on 26/12/2024.
//

import Foundation

let allStations: [Station] = [
    Station(id: "ALB", name: "Albertslund", latitude: 55.658056, longitude: 12.353889),
    Station(id: "LI", name: "Allerød", latitude: 55.871111, longitude: 12.356944),
    Station(id: "AVØ", name: "Avedøre", latitude: 55.625556, longitude: 12.455),
    Station(id: "BAV", name: "Bagsværd", latitude: 55.761667, longitude: 12.454444),
    Station(id: "BA", name: "Ballerup", latitude: 55.73, longitude: 12.357778),
    Station(id: "BFT", name: "Bernstorffsvej", latitude: 55.742778, longitude: 12.557778),
    Station(id: "BI", name: "Birkerød", latitude: 55.840278, longitude: 12.423889),
    Station(id: "BIT", name: "Bispebjerg", latitude: 55.706111, longitude: 12.541306),
    Station(id: "BSA", name: "Brøndby Strand", latitude: 55.620972, longitude: 12.421667),
    Station(id: "BØT", name: "Brøndbyøster", latitude: 55.665, longitude: 12.440833),
    Station(id: "BUD", name: "Buddinge", latitude: 55.747222, longitude: 12.493333),
    Station(id: "CB", name: "Carlsberg", latitude: 55.663408, longitude: 12.53645),
    Station(id: "CH", name: "Charlottenlund", latitude: 55.751667, longitude: 12.572222),
    Station(id: "DAH", name: "Danshøj", latitude: 55.664167, longitude: 12.493611),
    Station(id: "DBT", name: "Dybbølsbro", latitude: 55.665194, longitude: 12.559722),
    Station(id: "DYT", name: "Dyssegård", latitude: 55.7325, longitude: 12.535833),
    Station(id: "EGD", name: "Egedal", latitude: 55.779722, longitude: 12.185556),
    Station(id: "EMT", name: "Emdrup", latitude: 55.720278, longitude: 12.541389),
    Station(id: "FM", name: "Farum", latitude: 55.811944, longitude: 12.373889),
    Station(id: "FVT", name: "Favrholm", latitude: 55.911089, longitude: 12.314489),
    Station(id: "FL", name: "Flintholm", latitude: 55.685833, longitude: 12.499444),
    Station(id: "FS", name: "Frederikssund", latitude: 55.835833, longitude: 12.065556),
    Station(id: "FRH", name: "Friheden", latitude: 55.629167, longitude: 12.482778),
    Station(id: "FUT", name: "Fuglebakken", latitude: 55.695278, longitude: 12.526667),
    Station(id: "GJ", name: "Gentofte", latitude: 55.753611, longitude: 12.541528),
    Station(id: "GL", name: "Glostrup", latitude: 55.662917, longitude: 12.397222),
    Station(id: "GRE", name: "Greve", latitude: 55.581667, longitude: 12.296667),
    Station(id: "GHT", name: "Grøndal", latitude: 55.690556, longitude: 12.515361),
    Station(id: "HAR", name: "Hareskov", latitude: 55.766389, longitude: 12.405278),
    Station(id: "HL", name: "Hellerup", latitude: 55.730833, longitude: 12.566944),
    Station(id: "HER", name: "Herlev", latitude: 55.718889, longitude: 12.443611),
    Station(id: "HI", name: "Hillerød", latitude: 55.926389, longitude: 12.311111),
    Station(id: "HOT", name: "Holte", latitude: 55.807222, longitude: 12.468333),
    Station(id: "UND", name: "Hundige", latitude: 55.597778, longitude: 12.333611),
    Station(id: "HUT", name: "Husum", latitude: 55.71, longitude: 12.463333),
    Station(id: "HIT", name: "Hvidovre", latitude: 55.664444, longitude: 12.475),
    Station(id: "HTÅ", name: "Høje Taastrup", latitude: 55.648722, longitude: 12.269667),
    Station(id: "IH", name: "Ishøj", latitude: 55.613333, longitude: 12.357778),
    Station(id: "IST", name: "Islev", latitude: 55.699167, longitude: 12.469167),
    Station(id: "JSI", name: "Jersie", latitude: 55.521111, longitude: 12.20875),
    Station(id: "JYT", name: "Jyllingevej", latitude: 55.690278, longitude: 12.478056),
    Station(id: "JÆT", name: "Jægersborg", latitude: 55.761944, longitude: 12.520833),
    Station(id: "KLU", name: "Karlslunde", latitude: 55.566111, longitude: 12.268889),
    Station(id: "KBN", name: "KB Hallen", latitude: 55.677778, longitude: 12.492333),
    Station(id: "KET", name: "Kildebakke", latitude: 55.744722, longitude: 12.507778),
    Station(id: "KID", name: "Kildedal", latitude: 55.751944, longitude: 12.286944),
    Station(id: "KL", name: "Klampenborg", latitude: 55.776667, longitude: 12.588333),
    Station(id: "KH", name: "København H", latitude: 55.672778, longitude: 12.564444),
    Station(id: "NEL", name: "København Syd", latitude: 55.652361, longitude: 12.516389),
    Station(id: "KJ", name: "Køge", latitude: 55.457778, longitude: 12.186667),
    Station(id: "KJN", name: "Køge Nord", latitude: 55.49963, longitude: 12.1726),
    Station(id: "VAT", name: "Langgade", latitude: 55.6675, longitude: 12.504028),
    Station(id: "LY", name: "Lyngby", latitude: 55.768056, longitude: 12.503056),
    Station(id: "MPT", name: "Malmparken", latitude: 55.724583, longitude: 12.386389),
    Station(id: "MW", name: "Måløv", latitude: 55.747222, longitude: 12.318611),
    Station(id: "NHT", name: "Nordhavn", latitude: 55.706056, longitude: 12.5905),
    Station(id: "NØ", name: "Nørrebro", latitude: 55.700639, longitude: 12.53775),
    Station(id: "KN", name: "Nørreport", latitude: 55.683167, longitude: 12.571389),
    Station(id: "OP", name: "Ordrup", latitude: 55.7625, longitude: 12.583333),
    Station(id: "PBT", name: "Peter Bangs Vej", latitude: 55.678056, longitude: 12.503611),
    Station(id: "RYT", name: "Ryparken", latitude: 55.715556, longitude: 12.559722),
    Station(id: "RDO", name: "Rødovre", latitude: 55.664722, longitude: 12.458889),
    Station(id: "SJÆ", name: "Sjælør", latitude: 55.651528, longitude: 12.526667),
    Station(id: "SKT", name: "Skovbrynet", latitude: 55.765278, longitude: 12.434444),
    Station(id: "SKO", name: "Skovlunde", latitude: 55.723, longitude: 12.403056),
    Station(id: "SOL", name: "Solrød Strand", latitude: 55.533333, longitude: 12.218056),
    Station(id: "SFT", name: "Sorgenfri", latitude: 55.781389, longitude: 12.483056),
    Station(id: "SGT", name: "Stengården", latitude: 55.756667, longitude: 12.473056),
    Station(id: "ST", name: "Stenløse", latitude: 55.7675, longitude: 12.189722),
    Station(id: "SAM", name: "Svanemøllen", latitude: 55.7155, longitude: 12.577972),
    Station(id: "SYV", name: "Sydhavn", latitude: 55.654722, longitude: 12.5375),
    Station(id: "TÅ", name: "Taastrup", latitude: 55.6525, longitude: 12.302222),
    Station(id: "VAL", name: "Valby", latitude: 55.66375, longitude: 12.513889),
    Station(id: "VLB", name: "Vallensbæk", latitude: 55.623417, longitude: 12.3875),
    Station(id: "ANG", name: "Vangede", latitude: 55.739167, longitude: 12.524444),
    Station(id: "VAN", name: "Vanløse", latitude: 55.687111, longitude: 12.492111),
    Station(id: "VS", name: "Veksø", latitude: 55.75, longitude: 12.238889),
    Station(id: "VPT", name: "Vesterport", latitude: 55.6759, longitude: 12.5625),
    Station(id: "VGT", name: "Vigerslev Allé", latitude: 55.659722, longitude: 12.499167),
    Station(id: "VNG", name: "Vinge", latitude: 55.810278, longitude: 12.116667),
    Station(id: "VIR", name: "Virum", latitude: 55.796111, longitude: 12.473056),
    Station(id: "VÆR", name: "Værløse", latitude: 55.782222, longitude: 12.3725),
    Station(id: "ØLB", name: "Ølby", latitude: 55.48, longitude: 12.175278),
    Station(id: "ØL", name: "Ølstykke", latitude: 55.795833, longitude: 12.159167),
    Station(id: "KK", name: "Østerport", latitude: 55.6925, longitude: 12.587139),
    Station(id: "ÅLM", name: "Ålholm", latitude: 55.671944, longitude: 12.493194),
    Station(id: "ÅM", name: "Åmarken", latitude: 55.639722, longitude: 12.499806),
]