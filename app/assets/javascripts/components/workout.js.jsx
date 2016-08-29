var Workout = React.createClass({
  render: function(){
    return (
      <div>
        <p>{this.props.workout.body_weight.amount}</p>
        <p>{this.props.workout.routine_name}</p>
        <Exercises exercises={this.props.workout.exercises} />
      </div>
    );
  }
});
