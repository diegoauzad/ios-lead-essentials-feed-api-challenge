//
//  FeedImagesMapper.swift
//  FeedAPIChallenge
//
//  Created by Diego Mauricio Auza Derpic on 10/9/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final class FeedImagesMapper {
	struct Container: Decodable {
		private let items: [ImageItem]

		var feedImages: [FeedImage] {
			return items.map({ $0.feedImage })
		}
	}

	private struct ImageItem: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let image: URL

		enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case description = "image_desc"
			case location = "image_loc"
			case image = "image_url"
		}

		var feedImage: FeedImage {
			return FeedImage(id: id, description: description, location: location, url: image)
		}
	}

	static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		if response.statusCode == 200, let container = try? JSONDecoder().decode(FeedImagesMapper.Container.self, from: data) {
			return .success(container.feedImages)
		} else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
	}
}
