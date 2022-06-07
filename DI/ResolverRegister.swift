import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
   // defaultScope = .graph
      register {SelectSmileViewModel()}
      register {ARDelegate()}
  }
}
