import * as React from "react"
import { PlaceBrick } from "./placeBrick";
import { Flex, Sans, BorderBox, Separator } from "@artsy/palette";

export interface Props{
  places: Array<any>
  feature: string
}

export const FeaturedPlaces = (props: Props) => {
  return (
    <BorderBox maxWidth={450} m={2} flexDirection={"column"}>
      <Sans size={4} weight={"bold"}>{props.feature}</Sans>
      <Separator/>
      <Flex flexDirection="row" mt={2} flexWrap={"wrap"}>
        {props.places.map(p => <PlaceBrick key={p.id} place={p}/>)}
      </Flex>
    </BorderBox>
  )
}
