import * as React from "react"
import { Spinner, Flex, Sans, Image, Icon, MapPinIcon } from "@artsy/palette"

import Header from "../components/header"
import gql from "graphql-tag"
import { useQuery, useMutation } from "@apollo/react-hooks"
import { Questions } from "../components/questions"

interface Props {
  match: any
}

const FIND_PLACE_QUERY = gql`
  query FindPlace($id: ID!){
    place(id: $id) {
      id
      name
      location
      tags
      images {
        urls {
          thumb
          original
        }
      }
      stats {
        type
        response
        total
      }
    }
  }
`

const ADD_TO_LIST_MUTATION = gql`
  mutation AddToList($placeId: ID!, $listType: String!){
    addToList(placeId: $placeId, listType: $listType){
      id
    }
  }
`

export const PlaceDetail = (props: Props) => {
  const { loading, data } = useQuery(FIND_PLACE_QUERY, {variables: {id: props.match.params.placeId}})
  const [addToListMutation, { loading: addToListLoading, error: addToListError }] = useMutation(ADD_TO_LIST_MUTATION)
  if (loading) {
    return(
      <Flex flexDirection="column">
        <Header noLogin={false}/>
        <Spinner size="large"/>
      </Flex>
    )
  } else if (data) {
    return(
      <Flex flexDirection="column">
        <Header noLogin={false}/>
        <Flex flexDirection="column" justifyContent="space-between" m="auto">
          <Sans size={10}>{data.place.name}</Sans>
          <Image src={data.place.images[0].urls.original}/>
          <Flex flexDirection="row" justifyContent="space-between" m="auto" mt={1} mb={3}>
            <MapPinIcon width={25} height={25} style={{cursor: "copy"}} onClick={(e) => addToListMutation({variables: {placeId: data.place.id, listType: "planning_to_go"}})} />
          </Flex>
          <Sans size={3}>{data.place.tags.map(t => `#${t}`).join(" ")}</Sans>
          <Questions place={data.place}/>
        </Flex>
      </Flex>
    )
  }
}
