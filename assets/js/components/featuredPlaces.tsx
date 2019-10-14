import * as React from "react"
import { PlaceBrick } from "./placeBrick";
import { Flex, Sans, BorderBox, Separator, Serif } from "@artsy/palette";

export interface Props{
  places: Array<any>
  feature: string
}

export const FeaturedPlaces = (props: Props) => {
  return (
    <BorderBox maxWidth={400} m={2} flexDirection={"column"}>
      <Sans size={5} weight={"bold"}>{props.feature}</Sans>
      <Separator mb={2}/>
      <Flex flexDirection="column" alignContent="top">
        {props.places.map(p => <PlaceBrick key={p.id} place={p}/>)}
      </Flex>
    </BorderBox>
  )
}
