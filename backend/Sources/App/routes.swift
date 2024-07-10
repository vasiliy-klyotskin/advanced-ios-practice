import Vapor
import LoremSwiftum

func routes(_ app: Application) throws {
    app.get("list") { req -> PokemonListDTO in
        // Simulate delay
        Thread.sleep(until: Date() + 1)
        let data = PokemonData.shared
        do {
            let afterId = try req.query.get(Int.self, at: "after_id")
            let limit = try req.query.get(Int.self, at: "limit")
            return data.paginated(after: afterId, limit: limit)
        } catch {
            return data.fullPokemonList()
        }
    }

    app.get("test", "list") { req -> PokemonListDTO in
        PokemonListTestData.data
    }
    
    app.get("test", "detail") { req -> DetailPokemonDTO in
        PokemonDetailTestData.data
    }
    
    app.get("detail") { req -> DetailPokemonDTO in
        // Simulate delay
        Thread.sleep(until: Date() + 1)
        let id = try req.query.get(Int.self, at: "id")
        guard let detail = PokemonData.shared.detail(for: id) else {
            throw Abort(.badRequest, reason: "No such detail")
        }
        return detail
    }
}
