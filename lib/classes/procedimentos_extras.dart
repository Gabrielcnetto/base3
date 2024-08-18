
class Procedimentos_Extras {
  final String id;
  final String name;
  final int value;

  Procedimentos_Extras({
    required this.id,
    required this.name,
    required this.value,
  });
}

List<Procedimentos_Extras> procedimentosLista = [
    Procedimentos_Extras(
    id: "P0",
    name: "Corte",
    value: 12,
  ),
  Procedimentos_Extras(
    id: "P1",
    name: "Apenas barba",
    value: 12,
  ),
  Procedimentos_Extras(
    id: "P2",
    name: "Limpeza de pele",
    value: 12,
  ),
  Procedimentos_Extras(
    id: "P3",
    name: "Loção Facial",
    value: 12,
  ),
  Procedimentos_Extras(
    id: "P4",
    name: "Corte + Barboterapia",
    value: 12,
  ),
  Procedimentos_Extras(
    id: "P5",
    name: "Corte + Barbaexpress",
    value: 12,
  ),
];
