extends CollisionShape3D

var mesh:MeshInstance3D
var mesh_shape:BoxMesh
var _shape:BoxShape3D

func _ready() -> void:
  mesh = get_parent().get_node("WorldMesh")
  mesh_shape = mesh.mesh
  _shape = shape
  pass


func _on_world_mesh_property_list_changed() -> void:
  _shape.size = mesh_shape.size
  pass # Replace with function body.
