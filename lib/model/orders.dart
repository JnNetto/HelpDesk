class Orders {
  String? id;
  String? titulo;
  String? descricao;
  String? autor;
  String? dataDoChamado;
  bool? status;

  Orders(
      {this.id,
      this.titulo,
      this.descricao,
      this.autor,
      this.dataDoChamado,
      this.status});

  factory Orders.fromFirestore(var data, var id) {
    return Orders(
      id: id ?? '',
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'] ?? '',
      autor: data['autor'] ?? '',
      dataDoChamado: data['dataDoChamado'] ?? '',
      status: data['status'] ?? false,
    );
  }
}
