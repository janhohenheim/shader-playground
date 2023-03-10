#import bevy_pbr::mesh_types
#import bevy_pbr::mesh_view_bindings

struct ShaderRegionConfig {
    main_color: vec4<f32>,
    bottom_color: vec4<f32>,
};

@group(1) @binding(0)
var<uniform> mesh: Mesh;

@group(2) @binding(0)
var<uniform> config: ShaderRegionConfig;

#import bevy_pbr::mesh_functions

struct Vertex {
    // position of the local vertex in the blade
    @location(0) position: vec3<f32>,
    // position of the blade as an instance
    @location(1) position_field_offset: vec3<f32>,
    // height of the blade
    @location(2) height: f32,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) color: vec4<f32>,
};


@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
    var out: VertexOutput;
    var position = vertex.position.xyz * vec3<f32>(1.,vertex.height, 1.) + vertex.position_field_offset;

    out.clip_position = mesh_position_local_to_clip(mesh.model, vec4<f32>(position, 1.0));

    let lambda = 1.0 - vertex.position.y / vertex.height;
    let lambda = lambda * lambda * lambda;
    out.color = mix(config.main_color, config.bottom_color, lambda);
    return out;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    return in.color;
}