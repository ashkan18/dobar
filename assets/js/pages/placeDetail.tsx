import * as React from "react"
import { Spinner, Flex, Box, Button, Serif, BorderBox, space, color, Col, Image } from "@artsy/palette"

import Header from "../components/header";
import styled from 'styled-components';
import { Query } from "react-apollo";
import gql from "graphql-tag";


interface Props {
  match: any
}

const FIND_PLACE_QUERY = gql`
`

export default class PlaceDetail extends React.Component<Props, {}>{
  public render(){
    return(
      <Query query={FIND_PLACE_QUERY} variables={{id: this.props.match.params.placeId}}>
        {({ loading, error, data }) => {
          return (
            <>
              <Header noLogin={false}/>
              { loading && <Spinner size="large"/>}
              { error && <> Error! {error} </>}
              { !error && !loading && data &&
                <Flex flexDirection="row" justifyContent="space-between">
                  <BorderBox flexDirection="column" style={{width: 200}}>
                  </BorderBox>
                </Flex>
              }
            </>
          )
        }}
      </Query>
    )
  }
}
