class Produtosavenda {
  final String id;
  final String nome;
  final List<String>categorias;
  final String descricao;
  final int estoque;
  final double preco;
  final double precoAntigo;
  final int quantiavendida;
  bool ativoParaExibir;
  final String urlImage;

  Produtosavenda({
    required this.categorias,
    required this.ativoParaExibir,
    required this.descricao,
    required this.estoque,
    required this.id,
    required this.nome,
    required this.preco,
    required this.quantiavendida,
    required this.urlImage,
    required this.precoAntigo,
  });
}

List<Produtosavenda> produtosVendaLista = [
  Produtosavenda(
    categorias: [],
    ativoParaExibir: true,
    descricao: "produto para vender",
    estoque: 5,
    id: "",
    nome: "Creme de Barbear",
    preco: 49.90,
    quantiavendida: 1,
    urlImage: "",
    precoAntigo: 79.90,
  ),
 
];
