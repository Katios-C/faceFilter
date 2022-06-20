import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
   //   register {SelectSmileViewModel()}
      register {ARDelegate()}
  }
}

// эти классы должны реализовывать протокол и в
