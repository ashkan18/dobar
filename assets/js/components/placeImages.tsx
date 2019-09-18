import * as React from "react"
import { Flex, Image } from "@artsy/palette"


interface Props {
  images: Array<any> | null
}

export const PlaceImages = (props: Props) => {
  const {images} = props
  if (!images || images.length === 0) {
    return(null)
  }
  return(
    <Flex flexDirection="row" mt={2} flexWrap={"wrap"} justifyContent="center">
      {images.map( img => <Image src={img.urls.original} style={{maxHeight: 230}}/>)}
    </Flex>
  )
}