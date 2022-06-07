import SceneKit

class EmojiNode: SCNNode {
    
    var options: String
    var index = 0
    
    init(with options: String, width: CGFloat = 0.05, height: CGFloat = 0.05) {
        self.options = options
        
        super.init()
        
        let plane = SCNPlane(width: width, height: height)
        plane.firstMaterial?.diffuse.contents = (options ?? " ").image()
        plane.firstMaterial?.isDoubleSided = true
        geometry = plane
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom functions

extension EmojiNode {
    
    func updatePosition(for vectors: [vector_float3]) {
        let newPos = vectors.reduce(vector_float3(), +) / Float(vectors.count)
        position = SCNVector3(newPos)
    }
    
    func next() {
        index = (index + 1) % options.count
        
        if let plane = geometry as? SCNPlane {
            plane.firstMaterial?.diffuse.contents = options.image()
            plane.firstMaterial?.isDoubleSided = true
        }
    }
}
