Extension { #name : 'OptRectangle' }

{ #category : '*OSWindow-SDL2' }
OptRectangle >> asSDLRect [ 

^ SDL_Rect newX: originX rounded y: originY rounded w: (cornerX - originX) rounded h: (cornerY - originY) rounded
]
